# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Split fields like in Bash
setopt sh_word_split

setopt extended_glob

setopt vi

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey          '^V' edit-command-line
bindkey -M vicmd '^V' edit-command-line

mkdir -p "$XDG_CACHE_HOME/zsh" "$XDG_STATE_HOME/zsh"

# Completion
zmodload zsh/complist

bindkey -M menuselect '^A' send-break # abort
bindkey -M menuselect '^H' vi-backward-char # left
bindkey -M menuselect '^J' vi-down-line-or-history # down
bindkey -M menuselect '^K' vi-up-line-or-history # up
bindkey -M menuselect '^L' vi-forward-char # right
bindkey -M menuselect '^N' vi-forward-blank-word # next group
bindkey -M menuselect '^P' vi-backward-blank-word # previous group
bindkey -M menuselect '^T' accept-and-hold # hold
bindkey -M menuselect '^U' undo
bindkey -M menuselect '^Y' accept-and-infer-next-history # next

autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
zstyle ':completion:*' menu select  # Enable menu style completion
_comp_option+=(globdots)            # Include hidden files

zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completion"

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "$fg[yellow]%B--- %d%b"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # Color completion

zstyle ':completion:*' keep-prefix yes  # keep a prefix containing ~ or a param
zstyle ':completion:*' squeeze-slashes yes  # remove trailing slashes

# Source the generic shell configuration after compinit was loaded.  Otherwise,
# plugins will not be able to register completion.
source $HOME/.config/sh/rc.sh

# History
HISTSIZE=100000
SAVEHIST=$HISTSIZE
HISTFILE="$XDG_STATE_HOME/zsh/history"
setopt inc_append_history # Share history between zsh instances
setopt extended_history   # Save timestamps and duration
setopt hist_reduce_blanks # Remove superfluous blanks

# Help for builtin commands
unalias run-help
autoload -Uz run-help

# Go upwards quickly by typing sequences of dots
rationalise-dot() {
  if [[ $LBUFFER == *.. ]]; then
    LBUFFER+=/..
  else
    LBUFFER+=.
  fi
}
zle -N rationalise-dot
bindkey . rationalise-dot

# Next/previous history item which the command line is a prefix of
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^J' down-line-or-beginning-search # Down
bindkey '^K' up-line-or-beginning-search # Up

load_plugins "$HOME/.config/zsh/rc.d"

# Global aliases (enable them after the plugins to not affect their execution)
alias -g NE='2>/dev/null'
alias -g NUL='&>/dev/null'

alias -g C='| wc -l'
alias -g G='| rg'
alias -g H='| head'
alias -g L='| less'
alias -g S='| sort'
alias -g T='| tail'
alias -g U='| uniq'
alias -g V='| nvim'
alias -g X='| xargs'
