# shellcheck shell=bash

if type cdhist &>/dev/null; then
    source <(cdhist --init)
fi
