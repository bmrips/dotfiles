{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.zsh;
  setOpt = name: flag: "${if flag then "setopt" else "unsetopt"} ${name}";

in {

  options.programs.zsh = {

    enableViMode = mkEnableOption "Vim mode in Zsh";

    options = mkOption {
      type = with types; attrsOf bool;
      default = { };
      description = "Options to set or unset";
      example = { null_glob = true; };
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

    useInNixShell =
      mkEnableOption "zsh-nix-shell, i.e. to spawn Zsh in Nix shells";

  };

  config = mkMerge [

    (mkIf cfg.enableViMode { programs.zsh.defaultKeymap = "viins"; })

    (mkIf (cfg.options != { }) {
      programs.zsh.initExtra = concatLines (mapAttrsToList setOpt cfg.options);
    })

    (mkIf (cfg.siteFunctions != { }) {
      home.packages = mapAttrsToList
        (name: pkgs.writeTextDir "share/zsh/site-functions/${name}")
        cfg.siteFunctions;
    })

    (mkIf (cfg.useInNixShell) {
      home.packages = [ pkgs.zsh-nix-shell ];
      programs.zsh.initExtra = ''
        source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
      '';
    })

  ];

}
