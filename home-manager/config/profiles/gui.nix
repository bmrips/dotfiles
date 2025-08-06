{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  cfg = config.profiles.gui;

in
{
  options.profiles.gui = {
    enable = lib.mkEnableOption "the GUI profile.";
    extra.enable = lib.mkEnableOption "extra GUI applications.";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [

      {
        programs.firefox.enable = true;
        programs.keepassxc.enable = true;
        xdg.autostart.enable = true;
      }

      (lib.mkIf cfg.extra.enable {
        home.packages =
          with pkgs;
          [
            logseq
            spotify
            ungoogled-chromium
          ]
          ++ lib.optionals isLinux [
            libreoffice-qt
            vlc
          ];

        programs.signal-desktop.enable = true;
      })

    ]
  );
}
