# Ignore unused variables since they will be needed elsewhere
# shellcheck disable=SC2034

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source "$HOME/.config/sh/rc.sh"

# Check the window size after each command and, if necessary, update the
# values of LINES and COLUMNS
[[ -n $DISPLAY ]] && shopt -s checkwinsize

# The pattern "**" used in a pathname expansion context will match all files
# and zero or more directories and subdirectories.
shopt -s globstar

mkdir -p "$XDG_CACHE_HOME/bash" "$XDG_STATE_HOME/bash"

# History
HISTSIZE=10000
HISTFILESIZE=$HISTSIZE
HISTFILE="$XDG_STATE_HOME/bash/history"
HISTCONTROL=ignoreboth
shopt -s histappend

load_plugins "$HOME/.config/bash/rc.d"
