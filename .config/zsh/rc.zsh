# If not running interactively, don't do anything
[[ $- != *i* ]] && return

setopt +o nomatch
source $HOME/.config/sh/rc.sh
setopt -o nomatch

# Vi input mode
bindkey -v

# Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select  # Enable menu style completion
_comp_option+=(globdots)            # Include hidden files

# History
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE="$XDG_CACHE_HOME/zsh/history"
setopt inc_append_history   # Share history between zsh instances
setopt hist_ignore_all_dups # Remove duplicates
setopt hist_reduce_blanks   # Remove superfluous blanks

# Prompt {{{1

# Load the prompt modules
autoload -Uz promptinit
promptinit

# First prompt
PROMPT='%F{%(!.red.green)}%n%f@%F{blue}%m%f:%F{magenta}%0~%f %(!.#.$) '
PROMPT_NOCOLOR="${(S)${PROMPT//\%f}//\%[fF]\{*\}}"
RPROMPT='%F{yellow}$(__git_ps1 "(%s)")%f'

# Second prompt for continuation
PS2=$(printf "%${#$(print -Pn $PROMPT_NOCOLOR)}s" "> ")

# Set a git prompt if visiting a repository
setopt prompt_subst

# Git prompt options
GIT_PS1_SHOWDIRTYSTATE="on"         # + for staged, * if unstaged.
GIT_PS1_SHOWSTASHSTATE="on"         # $ if something is stashed.
GIT_PS1_SHOWUNTRACKEDFILES="on"     # % if there are untracked files.
GIT_PS1_SHOWUPSTREAM="on"           # <,>,<> behind, ahead of, or diverged from upstream.

# }}}1

setopt +o nomatch
load_plugins "$HOME/.config/zsh/rc.d"
setopt -o nomatch
