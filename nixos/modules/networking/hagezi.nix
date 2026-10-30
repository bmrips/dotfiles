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
        The set of blocklists that is used. The key is the name of list as in
        the download links of {url}`hagezi-mirror.dnsbunker.org`}.
      '';
      example."pro.plus".enable = true;
      default = { };
      type =
        let
          blocklist.options = {
            enable = lib.mkEnableOption "this blocklist" // {
              default = true;
            };
            hash = lib.mkOption {
              description = "The SRI hash of this list. Gets passed to `pkgs.fetchurl`.";
              default = lib.fakeHash;
              type = lib.types.str;
            };
            whitelist = lib.mkOption {
              description = "Whitelisted domains that will be removed from this list.";
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

      fetchBlocklist =
        name:
        { hash, whitelist, ... }:
        let
          orig = pkgs.fetchurl {
            url = "https://hagezi-mirror.dnsbunker.org/dnsmasq/${name}.txt";
            inherit hash;
          };
          pattern = lib.escape [ "." ] (lib.concatStringsSep "|" whitelist);
        in
        if whitelist == [ ] then
          orig
        else
          pkgs.runCommandLocal "HaGeZi-${name}.txt" { } ''
            grep -vE '${pattern}' <${orig} >$out
          '';
    in
    lib.mkIf cfg.enable {
      environment.etc = lib.mapAttrs' (name: spec: {
        name = "NetworkManager/dnsmasq.d/HaGeZi-${name}.conf";
        value.source = fetchBlocklist name spec;
      }) enabledBlocklists;

      networking.networkmanager.dns = "dnsmasq";

      # resolved conflicts with NetworkManager's dnsmasq.
      services.resolved.enable = lib.mkForce false;
    };
}
