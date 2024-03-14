source "$HOME/.config/sh/utilities.sh"

#[ Aliases ]# {{{1

# chgrp
alias chgrp='chgrp --preserve-root'

# chmod
alias chmod='chmod --preserve-root'

# chown
alias chown='chown --preserve-root'

# clipbaord
alias xc='wl-copy'
alias xp='wl-paste'

# cp
alias cp='cp --interactive'

# df
alias df='df --human-readable'

# diff
alias diff='diff --color=auto'

# dmesg
alias dmesg='dmesg --color=auto'

# du
alias du='du --human-readable'

# free
alias free='free --human'

# git
function git() {
    if [[ -n $1 && $1 == "cd-root" ]]; then
        declare -r top_level=$(env git rev-parse --show-toplevel)
        cd "$top_level" || return 1
    else
        env git "$@"
    fi
}

# glab
alias gl='glab'

# grep
alias grep='grep --binary-files=without-match --color=auto'

# ip
alias ip='ip -color=auto'

# ls
alias ls='ls --human-readable --color=auto --group-directories-first --time-style=long-iso --literal'
alias lsd='ls -d'
alias lsx='ls -X'
alias ls.='lsd .*'
alias ll='ls -l'
alias la='ll -A'
alias ld='ll -d'
alias lx='ll -X'
alias l.='ld .*'

# onefetch
alias onefetch='onefetch --true-color=never --no-color-palette --no-art --no-bots --include-hidden --no-title'

# make
alias make='make --jobs=$(nproc)'

# mkdir
mkcd() {
    mkdir -p "$1" && cd "$1" || return
}

# mv
alias mv='mv --interactive'

# nvim
alias nvim='TTY=$TTY nvim'
alias vi='nvim'
alias vim='nvim'

# open
alias open="xdg-open"

# rm
alias rm='rm --preserve-root'
alias trash='mv -t $XDG_DATA_HOME/Trash/files'

# stylua
alias stylua='stylua --search-parent-directories'

# tree
alias tree='tree -C --dirsfirst'

# wget
alias wget='wget --continue'

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

load_plugins "$HOME/.config/sh/rc.d"

# vi: fdm=marker
