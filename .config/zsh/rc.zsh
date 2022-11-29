# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source $HOME/.config/sh/rc.sh

setopt vi

bindkey -M viins 'jk' vi-cmd-mode
bindkey -M vicmd ' ' execute-named-cmd

autoload -U edit-command-line
zle -N edit-command-line
bindkey          '^V' edit-command-line
bindkey -M vicmd '^V' edit-command-line

# Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select  # Enable menu style completion
_comp_option+=(globdots)            # Include hidden files

zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/completion"

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "$fg[yellow]%B--- %d%b"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # Color completion

# History
HISTSIZE=100000
SAVEHIST=$HISTSIZE
HISTFILE="$XDG_CACHE_HOME/zsh/history"
setopt inc_append_history # Share history between zsh instances
setopt extended_history   # Save timestamps and duration
setopt hist_reduce_blanks # Remove superfluous blanks

# Next/previous history item which the command line is a prefix of
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^J' down-line-or-beginning-search # Down
bindkey '^K' up-line-or-beginning-search # Up

# vim-surround
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -a 'cs' change-surround
bindkey -a 'ds' delete-surround
bindkey -a 'ys' add-surround
bindkey -M visual 'S' add-surround

load_plugins "$HOME/.config/zsh/rc.d"
