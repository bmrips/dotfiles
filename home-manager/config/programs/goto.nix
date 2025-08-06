{ config, lib, ... }:

{
  home.shellAliases.b = lib.mkIf config.programs.goto.enable "goto";
  programs.goto.fzfWidget = {
    key = "^B";
    options = {
      border-label = lib.escapeShellArg " Bookmarks ";
      preview = lib.shell.dirPreview (lib.shell.subshell "echo {} | sed 's/^[a-zA-Z]* *//'");
    };
  };
}
