# Import utilities
source "$HOME/.config/sh/utilities.sh"

umask 022

prepend_path "$HOME/.local/bin"

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"

# Plugins
PLUGIN_DIR="$HOME/.config/sh/profile.d"
if [[ -d $PLUGIN_DIR ]]; then
	for plugin in $PLUGIN_DIR/*.sh; do
		[[ -r $plugin ]] && source "$plugin"
	done
	unset plugin
fi
unset PLUGIN_DIR
