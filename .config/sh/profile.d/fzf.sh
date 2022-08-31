# shellcheck shell=bash

export FZF_DEFAULT_COMMAND='fd --type f --hidden'
export FZF_DEFAULT_OPTS="--layout=reverse\
 --border=horizontal\
 --marker=❯\
 --prompt='❯ '\
 --pointer=❯\
 --color=bg+:0,info:8,border:8,prompt:13,pointer:12,marker:13,fg+:12,hl:9,hl+:9\
 --preview-window=right,border,hidden\
 --bind='f3:toggle-preview-wrap,f4:toggle-preview,f5:change-preview-window(nohidden,down|nohidden,left|nohidden,up|nohidden,right)'"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview='bat --plain --color=always --paging=never {}'"

export FZF_ALT_C_COMMAND='fd --type d --hidden'
export DIR_PREVIEW="ls -l --human-readable --color=always --group-directories-first --time-style=+t --literal {} | cut --delimiter=\" \" --fields=1,5- | sed \"s/ t / /\" | tail -n+2"
export FZF_ALT_C_OPTS="--preview='$DIR_PREVIEW'"

# Path and directory completion, e.g. for `cd .config/**`
_fzf_compgen_path() {
    fd --follow --hidden --exclude ".git" . "$1"
}
_fzf_compgen_dir() {
    fd --follow --hidden --exclude ".git" --type d . "$1"
}
