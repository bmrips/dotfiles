{ config, lib, pkgs, ... }:

with lib;

let
  readNixInitScript = ''
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  '';

  setBackgroundEnvVar = ''
    # determine the background from the iTerm profile
    export BACKGROUND="$(tr '[:upper:]' '[:lower:]' <<<"$ITERM_PROFILE")"
  '';

in {
  options.profiles.macos.enable = mkEnableOption "the macOS profile";

  config = mkIf config.profiles.macos.enable {

    home.homeDirectory = "/Users/${config.home.username}";

    home.packages = with pkgs; [ iterm2 rectangle unnaturalscrollwheels ];

    home.shellAliases = {
      xc = "pbcopy";
      xp = "pbpaste";
    };

    # Read Nix's initialisation script here to survive macOS system updates.
    programs.bash.profileExtra = readNixInitScript;
    programs.zsh.profileExtra = readNixInitScript;

    programs.bash.initExtra = setBackgroundEnvVar;
    programs.zsh.initExtra = setBackgroundEnvVar;

    programs.firefox.package = null;

    programs.fzf-tab-completion.enable = mkForce false;

    programs.git = {
      extraConfig.credential.helper = mkForce "osxkeychain";
      ignores = [ ".DS_Store" ]; # macOS directory preferences
    };

    services.home-manager.autoUpgrade.enable = mkForce false;

  };
}
