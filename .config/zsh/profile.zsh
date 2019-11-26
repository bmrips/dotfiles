setopt +o nomatch
source "$HOME/.config/sh/profile.sh"
setopt -o nomatch

# Plugins
setopt +o nomatch
PLUGIN_DIR="$HOME/.config/zsh/profile.d"
if [[ -d $PLUGIN_DIR ]]; then
	for plugin in $PLUGIN_DIR/*.zsh; do
		[[ -r $plugin ]] && source "$plugin"
	done
	unset plugin
fi
unset PLUGIN_DIR
setopt -o nomatch
