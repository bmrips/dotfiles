# shellcheck shell=bash

# Import utilities
source "$HOME/.config/sh/utilities.sh"

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"

#[ Aliases ]# {{{1

# chgrp
alias chgrp='chgrp --preserve-root'

# chmod
alias chmod='chmod --preserve-root'

# chown
alias chown='chown --preserve-root'

# clipbaord
if [ -n "$WAYLAND_DISPLAY" ]; then
    alias xc='wl-copy'
    alias xp='wl-paste'
else
    alias xc='xclip -selection clipboard -in'
    alias xp='xclip -selection clipboard -out'
fi

# cp
alias cp='cp -i'
alias cow='cp --reflink=auto'

# df
alias df='df -h'

# diff
alias diff='diff --color=auto'

# dmesg
alias dmesg='dmesg --color=auto'

# du
alias du='du -h'

# free
alias free='free -h'

# git
function git() {
    if [[ -n $1 && $1 = "cd-root" ]]; then
        cd "$(/usr/bin/git rev-parse --show-toplevel)" || return
    else
        /usr/bin/git "$@"
    fi
}

# glab
alias gl='glab'

# grep
alias grep='grep -I --color=auto'

# highlight
alias highlight='highlight --out-format=ansi'
alias hcat="highlight"

# ip
alias ip='ip -color=auto'

# ls
alias ls='ls --human-readable --color=auto --group-directories-first --time-style=long-iso --literal'
alias ls.='ls -d .*'
alias lsd='ls -d'
alias lsx='ls -X'
alias ll='ls -l'
alias la='ll -A'
alias l.='ll -d .*'
alias ld='ll -d'
alias lx='ll -X'

# make
alias make='make -j`nproc`'

# mv
alias mv='mv -i'

# neovide
alias neovide='neovide --maximized --notabs'
alias nv=neovide

# nvim
alias vi='nvim'
alias vim='nvim'

# open
alias open="xdg-open"

# pigz
alias gzip='pigz'
alias gunzip='unpigz'

# rm
alias rm='rm --preserve-root'
alias trash='mv -t $XDG_DATA_HOME/Trash/files'

# tree
alias tree='tree -C --dirsfirst'
alias gtree='tree --gitignore'

# wget
alias wget='wget -c'

# One-letter aliases
alias b=goto
alias c=cd
alias g=git
alias l=ll
alias o=open
alias t=gtree
alias v=nvim

# }}}1

load_plugins "$HOME/.config/sh/rc.d"

# vi: fdm=marker
