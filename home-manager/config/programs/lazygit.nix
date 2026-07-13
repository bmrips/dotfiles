{ config, lib, ... }:

{
  home.shellAliases.lg = lib.mkIf config.programs.lazygit.enable "lazygit";

  programs.lazygit.settings = {
    git = {
      overrideGpg = true;
      pagers = [
        { pager = "delta --paging=never --width=-1"; }
        { pager = "delta --paging=never --width=-1 --side-by-side"; }
      ];
    };
    gui = {
      authorColors = {
        "Benedikt Rips" = "cyan";
        "Rips, Benedikt" = "cyan";
      };
      nerdFontsVersion = "3";
      skipAmendWarning = true;
      skipDiscardChangeWarning = true;
      skipStashWarning = true;
      skipRewordInEditorWarning = true;
    };
    promptToReturnFromSubprocess = false;
  };
}
