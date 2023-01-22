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

# From the given list of files, source the first one that exists.
try_source() {
    for file in "$@"; do
        if [[ -r $file ]]; then
            # The source varies, hence can not be specified.
            # shellcheck source=/dev/null
            source "$file"
            unset file
            return
        fi
    done

    unset file
    return 1
}

# List the path fields line by line
path_fields() {
    (
        IFS=:
        for dir in $1; do
            echo "$dir"
        done
    )
}

# Searches the file on the share path and sources it
try_source_from_path() {
    for dir in $XDG_DATA_HOME $(path_fields "$XDG_DATA_DIRS"); do
        if try_source "$dir/$1"; then
            unset dir
            return
        fi
    done

    unset dir
    return 1
}
