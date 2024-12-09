{ config, lib, pkgs, ... }:

with lib;

let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  cfg = config.profiles.gui;

in {
  options.profiles.gui = {
    enable = mkEnableOption "the GUI profile";
    extra.enable = mkEnableOption "extra GUI applications";
  };

  config = mkIf cfg.enable (mkMerge [

    {
      programs.firefox.enable = true;
      programs.keepassxc.enable = true;
    }

    (mkIf config.profiles.gui.enable {
      home.packages = with pkgs;
        [ discord logseq prismlauncher spotify ungoogled-chromium ]
        ++ optionals isLinux [ libreoffice-qt vlc ];

      programs.signal-desktop.enable = true;
      programs.slack.enable = true;
    })

  ]);
}
