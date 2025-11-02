{ config, lib, ... }:

{
  home.shellAliases.lg = lib.mkIf config.programs.lazygit.enable "lazygit";

  programs.lazygit.settings = {
    gui = {
      nerdFontsVersion = "3";
      authorColors = {
        "Benedikt Rips" = "cyan";
        "Rips, Benedikt" = "cyan";
      };
    };
    git = {
      overrideGpg = true;
      paging = [ { pager = "delta --paging=never --width=-1"; } ];
    };
    promptToReturnFromSubprocess = false;
  };
}
