try_source_from_path fzf/completion.zsh
try_source_from_path fzf/key-bindings.zsh

# Select files with Ctrl+Space, history with Ctrl+/, directories with Ctrl+T
bindkey '^ ' fzf-file-widget
bindkey '^_' fzf-history-widget
bindkey '^T' fzf-cd-widget

bindkey -M vicmd '^R' redo  # restore redo

# preview when completing env vars (note: only works for exported variables)
# eval twice, first to unescape the string, second to expand the $variable
zstyle ':completion::*:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-completion-opts --preview='eval eval echo {1}' --preview-window=wrap

#[ Go to `goto` bookmark ]#
GOTO_DIR_PREVIEW='ls -l --human-readable --color=always --group-directories-first --time-style=+t --literal $(echo {} | sed "s/^[a-zA-Z]* *//") | cut --delimiter=" " --fields=1,5- | sed "s/ t / /" | tail -n+2'
FZF_GOTO_OPTS="--preview='$GOTO_DIR_PREVIEW'"

function fzf-goto-widget() {
    _goto_resolve_db
    local dir="$(sed 's/ /:/' $GOTO_DB | column --table --separator=: | FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_GOTO_OPTS" fzf | sed "s/^[a-zA-Z]* *//")"
    if [[ -z "$dir" ]]; then
        zle redisplay
        return 0
    fi
    zle push-line # Clear buffer. Auto-restored on next prompt.
    BUFFER="cd -- ${(q)dir}"
    zle accept-line
    local ret=$?
    zle reset-prompt
    return $ret
}

zle -N fzf-goto-widget
bindkey '^B' fzf-goto-widget

#[ Go to directory in cd history ]#
FZF_CDHIST_OPTS="--preview='$DIR_PREVIEW'"

function fzf-cdhist-widget() {
    local dir="$(sed "s#$HOME#~#" $XDG_STATE_HOME/cd_history | FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_CDHIST_OPTS" fzf | sed "s#~#$HOME#")"
    if [[ -z "$dir" ]]; then
        zle redisplay
        return 0
    fi
    zle push-line # Clear buffer. Auto-restored on next prompt.
    BUFFER="cd -- ${(q)dir}"
    zle accept-line
    local ret=$?
    zle reset-prompt
    return $ret
}

zle -N fzf-cdhist-widget
bindkey '^Y' fzf-cdhist-widget

#[ Interactive grep ]#
FZF_GREP_COMMAND="fzf-state get-source grep"
FZF_GREP_PREVIEW="bat --plain --color=always --paging=never --line-range=\$(fzf-state context {2}): --highlight-line={2} {1}"
FZF_GREP_OPTS="--multi --bind='$(fzf-state binds "$FZF_GREP_COMMAND {q}" || true)' --preview='$FZF_GREP_PREVIEW'"

function __fzf-grep-widget() {
    local item
    eval $FZF_GREP_COMMAND "" | FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_GREP_OPTS" fzf --bind="change:reload($FZF_GREP_COMMAND {q} || true)" --ansi --disabled --delimiter=: | sed 's/:.*$//' | uniq | while read item; do
        echo -n "${(q)item} "
    done
    local ret=$?
    echo
    return $ret
}

function fzf-grep-widget() {
    LBUFFER="${LBUFFER}$(__fzf-grep-widget)"
    local ret=$?
    zle reset-prompt
    return $ret
}

zle -N fzf-grep-widget
bindkey '^F' fzf-grep-widget
