# Append to the path
append_path() {
    case ":$PATH:" in
    *:"$1":*) ;;

    *)
        PATH="${PATH:+$PATH:}$1"
        ;;
    esac
    export PATH
}

# Prepend to the path
prepend_path() {
    case ":$PATH:" in
    *:"$1":*) ;;

    *)
        PATH="$1${PATH:+:$PATH}"
        ;;
    esac
    export PATH
}

# Load plugins from the given path
load_plugins() {
    for plugin in "$1"/*; do
        if [[ -r $plugin ]]; then
            # The source varies, hence can not be specified.
            # shellcheck source=/dev/null
            source "$plugin"
        fi
    done
    unset plugin
}

# Evaluate the output of the given command; potential errors are suppressed.
try_eval() {
    out="$("$@" 2>/dev/null)" && eval "$out" && unset out
}

# Source the given file if it exists
try_source() {
    # The source varies, hence can not be specified.
    # shellcheck source=/dev/null
    [[ -r $1 ]] && source "$1"
}
