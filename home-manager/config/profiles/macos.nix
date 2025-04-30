{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    hm
    mkEnableOption
    mkForce
    mkIf
    ;

  readNixInitScript = ''
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  '';

  disableAccentCharacterSuggestions = ''
    defaults write -g ApplePressAndHoldEnabled -bool false
  '';

  setBackgroundEnvVar = ''
    # determine the background from the iTerm profile
    export BACKGROUND="$(tr '[:upper:]' '[:lower:]' <<<"$ITERM_PROFILE")"
  '';

in
{
  options.profiles.macos.enable = mkEnableOption "the macOS profile.";

  config = mkIf config.profiles.macos.enable {

    assertions = [
      {
        assertion = pkgs.stdenv.isDarwin;
        message = "This profile is only available on macOS.";
      }
    ];

    # Need to create aliases because Spotlight doesn't consider symlinks.
    home.activation.link-apps = hm.dag.entryAfter [ "writeBarrier" ] (
      let
        aliasesDir = "${config.home.homeDirectory}/Applications/Home Manager Apps Aliases";
        find = "${pkgs.findutils}/bin/find";
      in
      ''
        rm --recursive --force "${aliasesDir}"
        mkdir --parents "${aliasesDir}"
        ${find} -L "$newGenPath/home-files/Applications/Home Manager Apps/" -maxdepth 1 -name '*.app' -exec sh -c '
          real_app=$(readlink --canonicalize "{}")
          target_app="${aliasesDir}/$(basename "{}")"
          echo "Alias \"$real_app\" to \"$target_app\""
          ${pkgs.mkalias}/bin/mkalias "$real_app" "$target_app"
        ' \;
      ''
    );

    home.homeDirectory = "/Users/${config.home.username}";

    home.packages = with pkgs; [
      iterm2
      rectangle
      unnaturalscrollwheels
    ];

    home.shellAliases = {
      xc = "pbcopy";
      xp = "pbpaste";
    };

    profiles.gui.enable = true;

    # Read Nix's initialisation script here to survive macOS system updates.
    programs.bash.profileExtra = readNixInitScript + disableAccentCharacterSuggestions;
    programs.zsh.profileExtra = readNixInitScript + disableAccentCharacterSuggestions;

    programs.bash.initExtra = setBackgroundEnvVar;
    programs.zsh.initContent = setBackgroundEnvVar;

    programs.fzf-tab-completion.enable = mkForce false;

    programs.git = {
      extraConfig.credential.helper = mkForce "osxkeychain";
      ignores = [ ".DS_Store" ]; # macOS directory preferences
    };

    services.home-manager.autoUpgrade.enable = mkForce false;

  };
}
