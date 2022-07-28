# shellcheck shell=bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source "$HOME/.config/sh/rc.sh"

# Check the window size after each command and, if necessary, update the
# values of LINES and COLUMNS
[[ -n $DISPLAY ]] && shopt -s checkwinsize

# The pattern "**" used in a pathname expansion context will match all files
# and zero or more directories and subdirectories.
shopt -s globstar

# Colors
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
ORANGE="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
MAGENTA="$(tput setaf 5)"
CYAN="$(tput setaf 6)"
GREY="$(tput setaf 7)"
WHITE="$(tput setaf 8)"
RESET="$(tput sgr0)"

# History
HISTSIZE=10000
HISTFILESIZE=$HISTSIZE
HISTFILE="$XDG_CACHE_HOME/bash/history"
HISTCONTROL=ignoreboth
shopt -s histappend

#[ Prompt ]#

# Set red color and '#' for root
if [[ $(whoami) = root ]]; then
    suffix="#"
    color="$RED"
else
    suffix="$"
    color="$GREEN"
fi

# First prompt
PS1='$(tput sc; rightprompt; tput rc)${color}\u${RESET}@${BLUE}\h${RESET}:${MAGENTA}\w${RESET} ${suffix} '

rightprompt() {
    printf "%*s" $COLUMNS "$(__git_ps1 '(%s)') "
}

# Git prompt options
GIT_PS1_SHOWDIRTYSTATE="on"         # + for staged, * if unstaged.
GIT_PS1_SHOWSTASHSTATE="on"         # $ if something is stashed.
GIT_PS1_SHOWUNTRACKEDFILES="on"     # % if there are untracked files.
GIT_PS1_SHOWUPSTREAM="on"           # <,>,<> behind, ahead, or diverged from upstream.

# Second prompt
ps2() {
    ps1="${USER}@${HOSTNAME}:${PWD/$HOME}${suffix} "
    printf "%${#ps1}s" "> "
}
PS2='$(ps2)'

load_plugins "$HOME/.config/bash/rc.d"
