{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.networking.hagezi = {
    enable = lib.mkEnableOption "the HaGeZi DNS blocklists";
    blocklists = lib.mkOption {
      description = ''
        The set of blocklists that is used. The key is the name of the list as
        in the download links of {url}`hagezi-mirror.dnsbunker.org`.
      '';
      example."pro.plus".enable = true;
      default = { };
      type =
        let
          blocklist.options = {
            enable = lib.mkEnableOption "this blocklist";
            whitelist = lib.mkOption {
              description = ''
                Whitelisted domains. Entries for these domains and all of
                their subdomains are removed from this list.
              '';
              example = [ "reddit.com" ];
              default = [ ];
              type = with lib.types; listOf str;
            };
          };
        in
        with lib.types;
        attrsOf (submodule blocklist);
    };
  };

  config =
    let
      cfg = config.networking.hagezi;
      enabledBlocklists = lib.filterAttrs (_: l: l.enable) cfg.blocklists;
      stateDir = "hagezi/dnsmasq";
    in
    lib.mkIf (cfg.enable && enabledBlocklists != { }) {
      networking.networkmanager.dns = "dnsmasq";

      # resolved conflicts with NetworkManager's dnsmasq.
      services.resolved.enable = lib.mkForce false;

      # conf-dir tolerates an empty directory, so no list has to exist before
      # the first download. The suffix filter also excludes the dot-prefixed
      # staging files.
      environment.etc."NetworkManager/dnsmasq.d/HaGeZi.conf".text = ''
        conf-dir=/var/lib/${stateDir},*.txt
      '';

      systemd = {
        # Creates the directory before NetworkManager starts dnsmasq
        tmpfiles.rules = [ "d %S/${stateDir} 0755 root root -" ];

        services.hagezi-blocklists-prune = {
          description = "Remove HaGeZi blocklists that are no longer enabled";
          wantedBy = [ "multi-user.target" ];
          before = [ "NetworkManager.service" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true; # stays active, so a changed unit is restarted on switch
            StateDirectory = stateDir;
          };
          enableStrictShellChecks = true;
          path = [
            pkgs.findutils
            config.networking.networkmanager.package
          ];
          script =
            let
              names = lib.attrNames enabledBlocklists;
            in
            /* bash */ ''
              removed=$(find "$STATE_DIRECTORY" -maxdepth 1 -type f -name '*.txt' \
                ${lib.concatMapStringsSep " " (n: "! -name ${lib.escapeShellArg "${n}.txt"}") names} \
                -print -delete)
              if [ -n "$removed" ]; then
                echo "removed: $removed"
                nmcli general reload dns-full || true # NetworkManager may not be running yet at boot
              fi
            '';
        };

        timers.hagezi-blocklists-refresh = {
          description = "Refresh the HaGeZi blocklists";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = "daily";
            Persistent = true;
            RandomizedDelaySec = "1h";
          };
        };
        services.hagezi-blocklists-refresh = {
          description = "Refresh the HaGeZi blocklists";
          after = [ "network-online.target" ];
          requires = [ "network-online.target" ];
          serviceConfig = {
            Type = "oneshot";
            Restart = "on-failure";
            RestartSec = "5min";
            StateDirectory = stateDir;
            PrivateTmp = true;
          };
          enableStrictShellChecks = true;
          path =
            let
              networkmanager = config.networking.networkmanager.package;
              dnsmasq =
                lib.findSingle (drv: drv.pname == "dnsmasq") (throw "dnsmasq derivation not found")
                  (throw "multiple dnsmasq derivation found")
                  networkmanager.buildInputs;
            in
            [
              dnsmasq
              networkmanager
              pkgs.coreutils
              pkgs.curl
              pkgs.diffutils
              pkgs.ripgrep
            ];
          script =
            let
              baseUrl = "https://hagezi-mirror.dnsbunker.org/dnsmasq";
              minLines = 100; # sanity check against empty or truncated downloads

              # Matches "/domain/" and "/sub.domain/" in dnsmasq lines such as
              # "local=/domain/", but not "/notdomain/".
              whitelistFilter =
                whitelist:
                lib.optionalString (whitelist != [ ])
                  "/[^/]*(${lib.concatMapStringsSep "|" lib.escapeRegex whitelist})[^/]*/";

              updateCalls = lib.concatMapAttrsStringSep "\n" (
                name: l:
                "update ${lib.escapeShellArg name} ${lib.escapeShellArg (whitelistFilter l.whitelist)} || failed=1"
              ) enabledBlocklists;
            in
            /* bash */ ''
              set -euo pipefail

              dir=$STATE_DIRECTORY
              tmp=$(mktemp -d)
              trap 'rm -rf "$tmp"; rm -f "$dir"/.*.txt.new' EXIT
              trap 'exit 1' INT TERM HUP

              failed=0
              changed=0

              # update NAME FILTER: download, filter, validate and install one list.
              # A failure leaves the previous version of that list in place.
              update() {
                local name=$1 filter=$2 raw list lines
                raw="$tmp/$name.raw"
                list="$tmp/$name.txt"

                curl -fsSL --retry 3 --max-time 120 -o "$raw" "${baseUrl}/$name.txt" || {
                  echo "$name: download failed" >&2
                  return 1
                }

                if [ -n "$filter" ]; then
                  # rg exits with 1 when no line is selected; the size check handles that
                  rg -v "$filter" "$raw" >"$list" || [ "$?" -eq 1 ] || return 1
                else
                  mv "$raw" "$list"
                fi

                lines=$(wc -l <"$list")
                if [ "$lines" -lt ${toString minLines} ]; then
                  echo "$name: only $lines lines, keeping the old list" >&2
                  return 1
                fi

                dnsmasq --test --conf-file="$list" || {
                  echo "$name: malformed dnsmasq syntax, keeping the old list" >&2
                  return 1
                }

                if cmp -s "$list" "$dir/$name.txt"; then
                  echo "$name: unchanged"
                  return 0
                fi

                # $tmp is on another filesystem; stage next to the target so the
                # final rename is atomic.
                install -m 0644 "$list" "$dir/.$name.txt.new" || return 1
                mv -f "$dir/.$name.txt.new" "$dir/$name.txt" || return 1
                echo "$name: updated ($lines lines)"
                changed=1
              }

              ${updateCalls}

              if [ "$changed" -eq 1 ]; then
                nmcli general reload dns-full || echo "could not reload NetworkManager's DNS" >&2
              fi
              exit "$failed"
            '';
        };
      };
    };
}
