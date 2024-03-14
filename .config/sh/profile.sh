source "$HOME/.config/sh/utilities.sh"

prepend_to_path PATH "$HOME/.local/bin"

# Add Nix' share directory
prepend_to_path XDG_DATA_DIRS "$XDG_STATE_HOME/nix/profile/share"

export BROWSER=firefox

load_plugins "$HOME/.config/sh/profile.d"
