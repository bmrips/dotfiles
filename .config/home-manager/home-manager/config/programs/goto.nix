{ config, lib, ... }:

let
  inherit (lib.shell) dirPreview subshell;

in
lib.mkMerge [

  {
    programs.goto.fzfWidgetOptions = {
      preview = dirPreview (subshell "echo {} | sed 's/^[a-zA-Z]* *//'");
    };
  }

  (lib.mkIf config.programs.goto.enable {
    home.shellAliases.b = "goto";
    programs.zsh.initExtra = ''
      # Go to `goto` bookmark
      zle -N fzf-goto-widget
      bindkey '^B' fzf-goto-widget
    '';
  })

]
