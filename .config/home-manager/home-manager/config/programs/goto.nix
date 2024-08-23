{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.goto;

  inherit (pkgs.lib.shell) dirPreview subshell;

in {
  config = (mkMerge [

    {
      programs.goto.fzfWidgetOptions = {
        preview = dirPreview (subshell "echo {} | sed 's/^[a-zA-Z]* *//'");
      };
    }

    (mkIf cfg.enable {
      home.shellAliases.g = "goto";
      programs.zsh.initExtra = ''
        # Go to `goto` bookmark
        autoload -Uz fzf-goto-widget
        zle -N fzf-goto-widget
        bindkey '^B' fzf-goto-widget
      '';
    })

  ]);
}
