try_source /home/bmr/projects/fzf-tab-completion/zsh/fzf-zsh-completion.sh
zstyle ':completion:*' fzf-search-display true  # search completion descriptions
zstyle ':completion:*' fzf-completion-opts --tiebreak=chunk  # do not skew the ordering
