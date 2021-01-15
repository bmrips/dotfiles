source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

# Select files with Ctrl+Space, directories with Ctrl+T
bindkey "^ " fzf-file-widget
bindkey "^T" fzf-cd-widget
