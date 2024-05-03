source "$HOME/.config/sh/utilities.sh"

# Add Nix' share directory
prepend_to_path XDG_DATA_DIRS "$XDG_STATE_HOME/nix/profile/share"

load_plugins "$HOME/.config/sh/profile.d"
