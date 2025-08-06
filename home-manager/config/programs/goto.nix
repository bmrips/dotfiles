{ config, lib, ... }:

lib.mkMerge [

  {
    programs.goto.fzfWidgetOptions = {
      border-label = lib.escapeShellArg " Bookmarks ";
      preview = lib.shell.dirPreview (lib.shell.subshell "echo {} | sed 's/^[a-zA-Z]* *//'");
    };
  }

  (lib.mkIf config.programs.goto.enable {
    home.shellAliases.b = "goto";
    programs.zsh.initContent = ''
      # Go to `goto` bookmark
      zle -N fzf-goto-widget
      bindkey '^B' fzf-goto-widget
    '';
  })

]
