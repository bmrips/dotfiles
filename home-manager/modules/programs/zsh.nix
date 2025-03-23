{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    attrNames
    concatLines
    concatStringsSep
    mapAttrsToList
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types
    ;
  cfg = config.programs.zsh;
  setOpt = name: flag: "${if flag then "setopt" else "unsetopt"} ${name}";

in
{

  options.programs.zsh = {

    enableViMode = mkEnableOption "Vim mode in Zsh.";

    options = mkOption {
      type = with types; attrsOf bool;
      default = { };
      description = "Options to set or unset";
      example = {
        null_glob = true;
      };
    };

    siteFunctions = mkOption {
      type = with types; attrsOf lines;
      default = { };
      description = ''
        Functions that are added to the Zsh environment and are subject to
        {command}`autoload`ing. The key is the name and the value is the body of
        the function to be autoloaded.
      '';
      example = {
        mkcd = ''
          mkdir --parents "$1" && cd "$1"
        '';
      };
    };

  };

  config = mkMerge [

    (mkIf cfg.enableViMode { programs.zsh.defaultKeymap = "viins"; })

    (mkIf (cfg.options != { }) {
      programs.zsh.initContent = concatLines (mapAttrsToList setOpt cfg.options);
    })

    (mkIf (cfg.siteFunctions != { }) {
      home.packages = mapAttrsToList (
        name: pkgs.writeTextDir "share/zsh/site-functions/${name}"
      ) cfg.siteFunctions;
      programs.zsh.initContent = concatStringsSep " " ([ "autoload -Uz" ] ++ attrNames cfg.siteFunctions);
    })

  ];

}
