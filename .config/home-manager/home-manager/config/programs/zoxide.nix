{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.zoxide;

  inherit (pkgs.lib) gnuCommandLine;
  inherit (pkgs.lib.shell) dirPreview subshell;

in mkIf cfg.enable {

  home.sessionVariables._ZO_FZF_OPTS = concatStringsSep " " [
    config.home.sessionVariables.FZF_DEFAULT_OPTS
    (gnuCommandLine {
      preview = dirPreview
        (subshell "echo {} | sed 's#^~#${config.home.homeDirectory}#'");
    })
  ];

  programs.zsh.siteFunctions.fzf-zoxide-widget = ''
    zle push-line
    local dir="$(${cfg.package}/bin/zoxide query --interactive)"
    if [[ -z "$dir" ]]; then
        zle redisplay
        return 0
    fi
    BUFFER="cd -- ''${(q)dir}"
    zle accept-line
    local ret=$?
    zle reset-prompt
    return $ret
  '';

  programs.zsh.initExtra = ''
    # Go to directory with zoxide
    zle -N fzf-zoxide-widget
    bindkey '^Y' fzf-zoxide-widget
  '';

}
