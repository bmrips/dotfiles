{ config, lib, pkgs, ... }:

with lib;

mkMerge [

  {
    programs.bash = {
      historyControl = [ "ignoredups" ];
      historyFile = "${config.xdg.stateHome}/bash/history";
    };
  }

  (mkIf config.programs.bash.enable {
    home.packages = with pkgs; [ nix-bash-completions ];
  })

]
