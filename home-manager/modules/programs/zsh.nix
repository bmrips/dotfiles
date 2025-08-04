{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    attrNames
    concatStringsSep
    mapAttrsToList
    mkIf
    mkOption
    types
    ;
  cfg = config.programs.zsh;

in
{

  options.programs.zsh.siteFunctions = mkOption {
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

  config = mkIf (cfg.siteFunctions != { }) {
    home.packages = mapAttrsToList (
      name: pkgs.writeTextDir "share/zsh/site-functions/${name}"
    ) cfg.siteFunctions;
    programs.zsh.initContent = concatStringsSep " " ([ "autoload -Uz" ] ++ attrNames cfg.siteFunctions);
  };

}
