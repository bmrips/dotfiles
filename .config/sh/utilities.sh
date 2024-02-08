# Expand the variable named by $1 into its value.
# For example: let a=HOME, then $(expand $a) == /home/me
expand() {
    if [[ -z ${1-} ]]; then
        printf 'expand: expected one argument\n' >&2
        return 1
    fi
    eval printf '%s' "\"\${$1:-}\""
}

# Append directory $3 to the path named $1 and delimited by $2.
# For example: append_to_path_with_delimiter : PATH $HOME/.local/bin
append_to_path_with_delimiter() {
    local -r delim="$1"
    local -r pathName="$2"
    local -r pathValue="$(expand "$pathName")"
    local dir="$3"
    if [[ -d $dir && "$delim$pathValue$delim" != *"$delim$dir$delim"* ]]; then
        export "$pathName=${pathValue:+$pathValue$delim}$dir"
    fi
}

append_to_path() {
    append_to_path_with_delimiter : "$@"
}

# Prepend directory $3 to the path named $1 and delimited by $2.
# For example: append_to_path_with_delimiter : PATH $HOME/.local/bin
prepend_to_path_with_delimiter() {
    local -r delim="$1"
    local -r pathName="$2"
    local -r pathValue="$(expand "$pathName")"
    local dir="$3"
    if [[ -d $dir && "$delim$pathValue$delim" != *"$delim$dir$delim"* ]]; then
        export "$pathName=$dir${pathValue:+$delim$pathValue}"
    fi
}

prepend_to_path() {
    prepend_to_path_with_delimiter : "$@"
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
    script="$("$@" 2>/dev/null)" && eval "$script" && unset script
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
            return
        fi
    done

    unset dir
    return 1
}
