{ config, lib, ... }:

let
  cfg = config.programs.zoxide;

  inherit (lib) escapeShellArg gnuCommandLine;
  inherit (lib.shell) dirPreview subshell;

in
lib.mkIf cfg.enable {

  home.sessionVariables._ZO_FZF_OPTS = lib.concatStringsSep " " [
    (gnuCommandLine {
      border-label = escapeShellArg " Recent directories ";
      preview = dirPreview (subshell "echo {} | sed 's#^~#${config.home.homeDirectory}#'");
    })
  ];

  programs.zsh.siteFunctions.fzf-zoxide-widget = ''
    zle push-line
    local dir="$(${cfg.package}/bin/zoxide query --list | FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $_ZO_FZF_OPTS" fzf --exit-0 --select-1 --no-multi)"
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

  programs.zsh.initContent = ''
    # Go to directory with zoxide
    zle -N fzf-zoxide-widget
    bindkey '^Y' fzf-zoxide-widget
  '';

}
