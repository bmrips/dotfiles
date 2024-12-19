{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkMerge [

  {
    programs.bash = {
      historyControl = [ "ignoredups" ];
      historyFile = "${config.xdg.stateHome}/bash/history";
    };
  }

  (lib.mkIf config.programs.bash.enable {
    home.packages = with pkgs; [ nix-bash-completions ];
  })

]
