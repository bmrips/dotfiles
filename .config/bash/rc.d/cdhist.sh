# Record working directory changes by hooking into the prompt.
__cdhist_oldpwd="$(pwd)"

function __cdhist_prompt_hook() {
    local -r retval pwd_tmp
    retval="$?"
    pwd_tmp="$(pwd)"

    if [[ $__cdhist_oldpwd != "$pwd_tmp" ]]; then
        __cdhist_oldpwd="$pwd_tmp"
        cdhist "$__cdhist_oldpwd" >/dev/null
    fi

    return "${retval}"
}

if [[ ${PROMPT_COMMAND:=} != *'__cdhist_prompt_hook'* ]]; then
    PROMPT_COMMAND="__cdhist_prompt_hook;${PROMPT_COMMAND#;}"
fi
