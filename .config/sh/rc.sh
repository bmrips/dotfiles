source "$HOME/.config/sh/utilities.sh"

# git
function git() {
    if [[ -n $1 && $1 == "cd-root" ]]; then
        declare -r top_level=$(env git rev-parse --show-toplevel)
        cd "$top_level" || return 1
    else
        env git "$@"
    fi
}

# mkdir
function mkcd() {
    mkdir --parents "$1" && cd "$1" || return
}

load_plugins "$HOME/.config/sh/rc.d"
