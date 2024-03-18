# Path and directory completion, e.g. for `cd .config/**`
_fzf_compgen_path() {
    fd --follow --hidden --exclude=".git" . "$1"
}
_fzf_compgen_dir() {
    fd --follow --hidden --exclude=".git" --type=directory . "$1"
}

# use ASCII arrow head in non-pseudo TTYs
if [[ $TTY == /dev/tty* ]]; then
    export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --marker='>' --pointer='>' --prompt='> '"
fi
