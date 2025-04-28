{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkIf
    mkOption
    ;

  cfg = config.programs.gh;

  yaml = pkgs.formats.yaml { };

in
{
  options.programs.gh.hosts = mkOption {
    inherit (yaml) type;
    default = { };
    description = "Host-specific configuration written to {file}`$XDG_CONFIG_HOME/gh/hosts.yml`.";
    example."github.com".user = "<your_username>";
  };

  config = mkIf cfg.enable {
    xdg.configFile = {
      "gh/hosts.yml" = mkIf (cfg.hosts != { }) {
        source = yaml.generate "gh-hosts.yml" cfg.hosts;
      };
    };
  };
}
