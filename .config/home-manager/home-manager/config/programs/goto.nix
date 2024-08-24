{ config, lib, pkgs, ... }:

with lib;

let inherit (pkgs.lib.shell) dirPreview subshell;

in mkMerge [

  {
    programs.goto.fzfWidgetOptions = {
      preview = dirPreview (subshell "echo {} | sed 's/^[a-zA-Z]* *//'");
    };
  }

  (mkIf config.programs.goto.enable {
    home.shellAliases.b = "goto";
    programs.zsh.initExtra = ''
      # Go to `goto` bookmark
      autoload -Uz fzf-goto-widget
      zle -N fzf-goto-widget
      bindkey '^B' fzf-goto-widget
    '';
  })

]
