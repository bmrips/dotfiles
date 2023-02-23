export LESS='--quiet --tabs=4 --LONG-PROMPT --RAW-CONTROL-CHARS --quit-if-one-screen --wheel-lines=3'

export LESS_TERMCAP_md=$'\e[93m' # Bold as bright yellow
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_us=$'\e[4m' # Underline as usual
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_so=$'\e[30;47m' # Dark grey statusline
export LESS_TERMCAP_se=$'\e[0m'

export LESSHISTFILE="$XDG_STATE_HOME/less/history"
