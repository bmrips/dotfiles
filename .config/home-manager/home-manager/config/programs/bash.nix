{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.bash;

in {
  config = mkMerge [
    {
      programs.bash = {
        historyControl = [ "ignoredups" ];
        historyFile = "${config.xdg.stateHome}/bash/history";
      };
    }

    (mkIf cfg.enable { home.packages = with pkgs; [ nix-bash-completions ]; })

  ];
}
