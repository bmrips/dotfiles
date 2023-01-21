# Find configuration file
for colors in {$XDG_CONFIG_HOME,/etc}/dircolors.conf; do
    if [[ -r $colors ]]; then
        try_eval dircolors --bourne-shell "$colors"
        return
    fi
done

# If no config file was found, use the defauls
try_eval dircolors --bourne-shell
