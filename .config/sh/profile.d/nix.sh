# Pin channels globally.
for file in "$XDG_CONFIG_HOME/nix/channels"/*.nix; do
    _bname="$(basename "$file")"
    prepend_to_path NIX_PATH "${_bname%.nix}=$file"
done
unset _bname
