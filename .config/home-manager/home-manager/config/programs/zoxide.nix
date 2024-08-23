{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.zoxide;

  inherit (pkgs.lib) gnuCommandLine;
  inherit (pkgs.lib.shell) dirPreview subshell;

in {
  config = mkIf cfg.enable {

    home.sessionVariables._ZO_FZF_OPTS = concatStringsSep " " [
      config.home.sessionVariables.FZF_DEFAULT_OPTS
      (gnuCommandLine {
        preview = dirPreview
          (subshell "echo {} | sed 's#^~#${config.home.homeDirectory}#'");
      })
    ];

    programs.zsh.siteFunctions.fzf-zoxide-widget = ''
      zle push-line
      BUFFER="zi"
      zle accept-line
      local ret=$?
      zle reset-prompt
      return $ret
    '';

    programs.zsh.initExtra = ''
      # Go to directory with zoxide
      autoload -Uz fzf-zoxide-widget
      zle -N fzf-zoxide-widget
      bindkey '^Y' fzf-zoxide-widget
    '';

  };
}
