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

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "$fg[yellow]%B--- %d%b"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # Color completion

# History
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE="$XDG_CACHE_HOME/zsh/history"
setopt inc_append_history   # Share history between zsh instances
setopt hist_ignore_all_dups # Remove duplicates
setopt hist_reduce_blanks   # Remove superfluous blanks

setopt +o nomatch
load_plugins "$HOME/.config/zsh/rc.d"
setopt -o nomatch
