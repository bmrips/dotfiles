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
