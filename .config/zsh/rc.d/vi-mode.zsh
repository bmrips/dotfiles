bindkey -M viins 'jk' vi-cmd-mode
bindkey -M vicmd ' ' execute-named-cmd

# Increment with <C-a>
autoload -Uz incarg
zle -N incarg
bindkey -M vicmd '^A' incarg

# Text operators for quotes and blocks.
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in viopp visual; do
    for c in {a,i}${(s..)^:-q\'\"\`}; do
        bindkey -M $km -- $c select-quoted
    done
    for c in {a,i}${(s..)^:-'bB()[]{}<>'}; do
        bindkey -M $km -- $c select-bracketed
    done
done

# vim-surround
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -a 'cs' change-surround
bindkey -a 'ds' delete-surround
bindkey -a 'ys' add-surround
bindkey -M visual 'S' add-surround
