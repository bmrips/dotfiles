arrow_head=$([[ $TTY == /dev/tty* ]] && echo '>' || echo '❯')

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --marker='$arrow_head'\
 --prompt='$arrow_head '\
 --pointer='$arrow_head'"
