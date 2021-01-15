# Dynamic title for VTE based terminals.
case "$TERM" in
    vte*|xterm*)
        autoload -Uz add-zsh-hook

        function xterm_title_precmd () {
            print -Pn -- "\\e]2;${PROMPT_NOCOLOR%???}\a"
        }

        function xterm_title_preexec () {
            print -Pn -- "\\e]2;${PROMPT_NOCOLOR}${(q)1}\a"
        }

        add-zsh-hook -Uz precmd xterm_title_precmd
        add-zsh-hook -Uz preexec xterm_title_preexec
esac
