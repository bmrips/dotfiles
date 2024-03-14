export FZF_COMPLETION_OPTS="--height=80%"

# Path and directory completion, e.g. for `cd .config/**`
_fzf_compgen_path() {
    fd --follow --hidden --exclude=".git" . "$1"
}
_fzf_compgen_dir() {
    fd --follow --hidden --exclude=".git" --type=directory . "$1"
}

arrow_head=$([[ $TTY == /dev/tty* ]] && echo '>' || echo '❯')

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --marker='$arrow_head'\
 --prompt='$arrow_head '\
 --pointer='$arrow_head'"
