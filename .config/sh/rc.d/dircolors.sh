# shellcheck shell=bash

# Find configuration file
for colors in {$XDG_CONFIG_HOME,/etc}/dircolors.conf; do
	if [[ -r $colors ]]; then
		COLORS="$colors"
		break
	fi
done

# Exexcute dircolors if $COLORS file exists
if [[ -n $COLORS ]]; then
    eval "$(dircolors --bourne-shell "$COLORS" 2>/dev/null)"
fi
