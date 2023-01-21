source "$HOME/.config/sh/utilities.sh"

#[ Aliases ]# {{{1

# chgrp
alias chgrp='chgrp --preserve-root'

# chmod
alias chmod='chmod --preserve-root'

# chown
alias chown='chown --preserve-root'

# clipbaord
if [[ -n $WAYLAND_DISPLAY ]]; then
    alias xc='wl-copy'
    alias xp='wl-paste'
else
    alias xc='xclip -selection clipboard -in'
    alias xp='xclip -selection clipboard -out'
fi

# cp
alias cp='cp --interactive'
alias cow='cp --reflink=auto'

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

# highlight
alias highlight='highlight --out-format=ansi'
alias hcat="highlight"

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

# make
alias make='make --jobs=$(nproc)'

# mkdir
mkcd() {
    mkdir -p "$1" && cd "$1" || return
}

# mv
alias mv='mv --interactive'

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
alias wget='wget --continue'

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
