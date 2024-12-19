{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = lib.mkIf config.programs.bash.enable [ pkgs.nix-bash-completions ];

  programs.bash = {
    historyControl = [ "ignoredups" ];
    historyFile = "${config.xdg.stateHome}/bash/history";
  };
}
