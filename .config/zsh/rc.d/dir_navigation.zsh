# Go back with <M-Left>
function cd_undo() {
    zle push-line
    BUFFER="popd"
    zle accept-line
    local ret=$?
    zle reset-prompt
    return $ret
}

setopt auto_pushd
zle -N cd_undo
bindkey '^O' cd_undo

# Go to parent dir with <M-Up>
function cd_parent() {
    zle push-line
    BUFFER="cd .."
    zle accept-line
    local ret=$?
    zle reset-prompt
    return $ret
}

zle -N cd_parent
bindkey '^P' cd_parent
