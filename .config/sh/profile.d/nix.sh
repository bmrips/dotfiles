# Pin channels globally.
for file in "$XDG_CONFIG_HOME/nix/channels"/*.nix; do
    _bname="$(basename "$file")"
    prepend_to_path NIX_PATH "${_bname%.nix}=$file"
done
unset _bname

# Export this system's locales. See https://nixos.wiki/wiki/Locales.
export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive
