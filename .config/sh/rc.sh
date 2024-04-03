source "$HOME/.config/sh/utilities.sh"

#[ Aliases ]# {{{1

# settings
alias chgrp='chgrp --preserve-root'
alias chmod='chmod --preserve-root'
alias chown='chown --preserve-root'
alias cp='cp --interactive'
alias df='df --human-readable'
alias diff='diff --color=auto'
alias dmesg='dmesg --color=auto'
alias du='du --human-readable'
alias free='free --human'
alias grep='grep --binary-files=without-match --color=auto'
alias ip='ip -color=auto'
alias make='make --jobs=$(nproc)'
alias mv='mv --interactive'
alias nvim='TTY=$TTY nvim'
alias onefetch='onefetch --true-color=never --no-color-palette --no-art --no-bots --include-hidden --no-title'
alias rm='rm --preserve-root'
alias stylua='stylua --search-parent-directories'
alias tree='tree -C --dirsfirst'
alias wget='wget --continue'

# actual aliases
alias gl='glab'
alias hm='home-manager'
alias l.='ld .*'
alias la='ll -A'
alias ld='ll -d'
alias ll='ls -l'
alias ls.='lsd .*'
alias ls='ls --human-readable --color=auto --group-directories-first --time-style=long-iso --literal'
alias lsd='ls -d'
alias lsx='ls -X'
alias lx='ll -X'
alias open="xdg-open"
alias trash='mv -t $XDG_DATA_HOME/Trash/files'
alias vi='nvim'
alias vim='nvim'
alias xc='wl-copy'
alias xp='wl-paste'

# One-letter aliases
alias b=goto
alias c=cd
alias g=git
alias k=kubectl
alias l=ll
alias o=open
alias p=podman
alias t='tree --gitignore'
alias v=nvim

# }}}1

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

# vi: fdm=marker
