{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.glab;

  yaml = pkgs.formats.yaml { };

in
{
  options.programs.glab = {
    enable = lib.mkEnableOption "{command}`glab`.";
    package = lib.mkPackageOption pkgs "glab" { };
    aliases = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
      description = "Aliases written to {file}`$XDG_CONFIG_HOME/glab-cli/aliases.yml`.";
      example.co = "mr checkout";
    };
    settings = lib.mkOption {
      inherit (yaml) type;
      default = { };
      description = "Configuration written to {file}`$XDG_CONFIG_HOME/glab-cli/config.yml`.";
      example.check_update = false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."glab-cli/aliases.yml" = lib.mkIf (cfg.aliases != { }) {
      source = yaml.generate "glab-cli_aliases.yml" cfg.aliases;
    };

    home.activation.applyGlabConfig =
      let
        configFile = "${config.xdg.configHome}/glab-cli/config.yml";
      in
      # The `home.file` mechanism fails in this case since glab requires its
      # configuration file to have 0600 permissions and to be owned by the user.
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run mkdir $VERBOSE_ARG -p '${config.xdg.configHome}/glab-cli'
        run touch '${configFile}'
        run ${pkgs.yq-go}/bin/yq --inplace $VERBOSE_ARG '. *= load("${yaml.generate "glab-cli_config.yml" cfg.settings}")' '${configFile}'
        run chmod $VERBOSE_ARG 0600 ${configFile}
      '';
  };
}
