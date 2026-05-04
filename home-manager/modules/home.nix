{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.home;

  fileSubmodule = lib.types.submodule {
    options = {
      enable = lib.mkOption {
        description = "Whether this file shall be overridden.";
        default = true;
        type = lib.types.bool;
      };
      mode = lib.mkOption {
        description = "Mode of the file, given in octal digits.";
        example = "0600";
        default = null;
        type = with lib.types; nullOr (strMatching "[[:digit:]]{3,4}");
      };
      sources = lib.mkOption {
        description = "The files that will be merged into the target.";
        type = with lib.types; listOf (either path pathWithDeps);
        apply = map (x: if lib.types.path.check x then { path = x; } else x);
      };
      type = lib.mkOption {
        description = ''
          The type of the file. It determines how the sources are merged into
          the target.
        '';
        type = lib.types.enum (lib.attrNames lib.merge);
      };
    };
  };

  enabledFiles = lib.filterAttrs (_: s: s.enable) cfg.file';

  serviceName = path: "home-manager-merge-${utils.escapeSystemdPath path}";

in
{

  options.home = {

    defaultCommandFlags = lib.mkOption {
      type =
        with lib.types;
        attrsOf (
          attrsOf (oneOf [
            bool
            int
            str
          ])
        );
      default = { };
      description = "Default flags for shell commands";
      example = {
        grep.binary-files = "without-match";
        ls.color = true;
        make.jobs = 4;
      };
    };

    file' = lib.mkOption {
      type = lib.types.attrsOf fileSubmodule;
      default = { };
      description = ''
        Attribute set of files that, in contrast to {option}`home.file`, not
        linked into the user home, but merged.  Thus, existing configuration
        will not be wiped but partially overridden.
      '';
    };

  };

  config = {
    assertions = lib.flip lib.mapAttrsToList enabledFiles (
      path: spec: {
        assertion = spec.sources != [ ];
        message = ''
          No sources defined for ${
            lib.options.showOption [
              "home"
              "file'"
              path
            ]
          }.
        '';
      }
    );

    home.shellAliases = lib.mapAttrs (
      prog: opts: "${prog} ${lib.gnuCommand.line opts}"
    ) cfg.defaultCommandFlags;

    systemd.user.services = lib.flip lib.mapAttrs' enabledFiles (
      path: spec:
      let
        targetFile = "${config.home.homeDirectory}/${path}";
        sources = lib.unique (map (s: s.path) spec.sources);
        dependencies = lib.unique (lib.concatMap (s: s.dependsOn or [ ]) spec.sources);
        script =
          let
            name = "merge_${path}.sh";
            drv = pkgs.writeShellApplication {
              inherit name;
              runtimeInputs = [ pkgs.coreutils ];
              text =
                /* bash */ ''
                  mkdir -p "$(dirname '${targetFile}')"
                  touch '${targetFile}'
                ''
                + lib.merge.${spec.type} targetFile sources
                + lib.optionalString (spec.mode != null) /* bash */ ''
                  chmod ${spec.mode} ${targetFile}
                '';
            };
          in
          "${drv}/bin/${name}";
      in
      lib.nameValuePair (serviceName path) {
        Unit = {
          Description = "Merge Home Manager configuration into '${path}'";
          After = dependencies;
          Requires = dependencies;
        };
        Install.WantedBy = dependencies;
        Service = {
          Type = "oneshot";
          ExecStart = "${script}";
          X-Restart-Triggers = sources;
        };
      }
    );
  };

}
