{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.programs.glab;

  yaml = pkgs.formats.yaml { };

in
{
  options.programs.glab = {
    enable = mkEnableOption "{command}`glab`.";
    package = mkPackageOption pkgs "glab" { };
    aliases = mkOption {
      type = with types; attrsOf str;
      default = { };
      description = "Aliases written to {file}`$XDG_CONFIG_HOME/glab-cli/aliases.yml`.";
      example.co = "mr checkout";
    };
    settings = mkOption {
      inherit (yaml) type;
      default = { };
      description = "Configuration written to {file}`$XDG_CONFIG_HOME/glab-cli/config.yml`.";
      example.check_update = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."glab-cli/aliases.yml" = mkIf (cfg.aliases != { }) {
      source = yaml.generate "glab-cli_aliases.yml" cfg.aliases;
    };

    home.activation.glab-config =
      let
        configFile = "${config.xdg.configHome}/glab-cli/config.yml";
      in
      # The `home.file` mechanism fails in this case since glab requires its
      # configuration file to have 0600 permissions and to be owned by the user.
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run mkdir -p '${config.xdg.configHome}/glab-cli'
        run touch '${configFile}'
        run ${pkgs.yq-go}/bin/yq --inplace $VERBOSE_ARG '. *= load("${yaml.generate "glab-cli_config.yml" cfg.settings}")' '${configFile}'
        run chmod 0600 ${configFile}
      '';
  };
}
