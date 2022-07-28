export FZF_DEFAULT_COMMAND='fd --type f --hidden'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden'

export FZF_DEFAULT_OPTS="--layout=reverse --border=horizontal --marker=❯ --prompt='❯ ' --pointer=❯\
 --color=bg+:0,info:8,border:8,prompt:13,pointer:12,marker:13,fg+:12,hl:9,hl+:9"

# Path and directory completion, e.g. for `cd .config/**`
_fzf_compgen_path() {
    fd --follow --hidden --exclude ".git" . "$1"
}
_fzf_compgen_dir() {
    fd --follow --hidden --exclude ".git" --type d . "$1"
}
