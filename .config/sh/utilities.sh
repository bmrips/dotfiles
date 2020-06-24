# Append to the path
append_path () {
	case ":$PATH:" in
		*:"$1":*)
			;;
		*)
			PATH="${PATH:+$PATH:}$1"
	esac
    export PATH
}

# Prepend to the path
prepend_path () {
	case ":$PATH:" in
		*:"$1":*)
			;;
		*)
			PATH="$1${PATH:+:$PATH}"
	esac
    export PATH
}

# Load plugins from the given path
load_plugins () {
    for plugin in $1/*; do
        if [[ -r "$plugin" ]]; then
            source "$plugin"
        fi
    done
    unset plugin
}
