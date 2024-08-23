{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.goto;

  inherit (pkgs.lib) gnuCommandLine;
  inherit (pkgs.lib.shell) dirPreview subshell;

in {
  config = mkIf cfg.enable {

    home.sessionVariables.FZF_GOTO_OPTS = gnuCommandLine {
      preview = dirPreview (subshell "echo {} | sed 's/^[a-zA-Z]* *//'");
    };

    home.shellAliases.g = "goto";

    programs.zsh.initExtra = ''
      # Go to `goto` bookmark
      autoload -Uz fzf-goto-widget
      zle -N fzf-goto-widget
      bindkey '^B' fzf-goto-widget
    '';

  };
}
