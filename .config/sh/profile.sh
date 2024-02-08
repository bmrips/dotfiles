source "$HOME/.config/sh/utilities.sh"

umask 022

prepend_to_path PATH "$HOME/.local/bin"

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Add Nix' share directory
prepend_to_path XDG_DATA_DIRS "$XDG_STATE_HOME/nix/profile/share"

export EDITOR=nvim
export VISUAL=$EDITOR

export BROWSER=firefox

load_plugins "$HOME/.config/sh/profile.d"
