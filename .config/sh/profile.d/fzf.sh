export FZF_DEFAULT_COMMAND="fd --type=file --hidden"
export FZF_DEFAULT_OPTS="--layout=reverse\
 --height=60%\
 --border=horizontal\
 --marker=❯\
 --prompt='❯ '\
 --pointer=❯\
 --color=16,info:8,border:8\
 --preview-window=right,border,hidden\
 --bind='ctrl-f:half-page-down,ctrl-b:half-page-up,alt-a:toggle-all,f3:toggle-preview-wrap,f4:toggle-preview,f5:change-preview-window(nohidden,down|nohidden,left|nohidden,up|nohidden,right)'"

export FZF_CTRL_T_COMMAND="fzf-state get-source files"

# Errors during the export can be ignored safely since it has no effect.
# shellcheck disable=SC2155
export FZF_CTRL_T_OPTS="--preview='bat --plain --color=always --paging=never {}' --bind='$(fzf-state binds "$FZF_CTRL_T_COMMAND")'"

export FZF_ALT_C_COMMAND="fzf-state get-source directories"
export DIR_PREVIEW='ls -l --human-readable --color=always --group-directories-first --time-style=+t --literal {} | cut --delimiter=" " --fields=1,5- | sed "s/ t / /" | tail -n+2'

# Errors during the export can be ignored safely since it has no effect.
# shellcheck disable=SC2155
export FZF_ALT_C_OPTS="--preview='$DIR_PREVIEW' --bind='$(fzf-state binds "$FZF_ALT_C_COMMAND")'"

export FZF_COMPLETION_OPTS="--height=80%"

# Path and directory completion, e.g. for `cd .config/**`
_fzf_compgen_path() {
    fd --follow --hidden --exclude=".git" . "$1"
}
_fzf_compgen_dir() {
    fd --follow --hidden --exclude=".git" --type=directory . "$1"
}
