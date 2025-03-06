{
  programs.fzf-tab-completion = {
    fzfOptions.height = "60%";
    prompt = "❯ ";
    zshExtraConfig = ''
      zstyle ':completion:*' fzf-search-display true  # search completion descriptions
      zstyle ':completion:*' fzf-completion-opts --tiebreak=chunk  # do not skew the ordering

      keys=(
          ctrl-y:accept:'repeat-fzf-completion'  # accept the completion and retrigger it
          alt-enter:accept:'zle accept-line'  # accept the completion and run it
      )
      zstyle ':completion:*' fzf-completion-keybindings "''${keys[@]}"

      # Also accept and retrigger completion when pressing / when completing cd
      zstyle ':completion::*:cd:*' fzf-completion-keybindings "''${keys[@]}" /:accept:'repeat-fzf-completion'
    '';
  };
}
