# Plugins
PLUGIN_DIR="$HOME/.config/sh/logout.d"
if [[ -d $PLUGIN_DIR ]]; then
	for plugin in $PLUGIN_DIR/*.sh; do
		[[ -r $plugin ]] && source "$plugin"
	done
	unset plugin
fi
unset PLUGIN_DIR
