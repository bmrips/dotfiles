source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

# Select files with Ctrl+Space, directories with Ctrl+T
bindkey "^ " fzf-file-widget
bindkey "^T" fzf-cd-widget

source /usr/share/fzf-tab-completion/zsh/fzf-zsh-completion.sh
zstyle ':completion:*' fzf-search-display true # Search completion descriptions

# preview when completing env vars (note: only works for exported variables)
# eval twice, first to unescape the string, second to expand the $variable
zstyle ':completion::*:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-completion-opts --preview='eval eval echo {1}' --preview-window=wrap
