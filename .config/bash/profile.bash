source "$HOME/.config/sh/profile.sh"

# Plugins
PLUGIN_DIR="$HOME/.config/bash/profile.d"
if [[ -d $PLUGIN_DIR ]]; then
	for plugin in $PLUGIN_DIR/*.bash; do
		[[ -r $plugin ]] && source "$plugin"
	done
	unset plugin
fi
unset PLUGIN_DIR
