source "$HOME/.config/sh/utilities.sh"

umask 022

prepend_path "$HOME/.local/bin"

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Add Nix's resources directory
if [[ -d $HOME/.nix-profile ]]; then
    export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"
fi

export EDITOR=nvim
export VISUAL=$EDITOR

export BROWSER=firefox

load_plugins "$HOME/.config/sh/profile.d"
