# Record working directory changes by hooking into chpwd.
function __cdhist_chpwd_hook() {
    cdhist "$(pwd)" >/dev/null
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd __cdhist_chpwd_hook
