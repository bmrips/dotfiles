{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    optionals
    ;
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  cfg = config.profiles.gui;

in
{
  options.profiles.gui = {
    enable = mkEnableOption "the GUI profile";
    extra.enable = mkEnableOption "extra GUI applications";
  };

  config = mkIf cfg.enable (mkMerge [

    {
      programs.firefox.enable = true;
      programs.keepassxc.enable = true;
      xdg.autostart.enable = true;
    }

    (mkIf cfg.extra.enable {
      home.packages =
        with pkgs;
        [
          logseq
          spotify
          ungoogled-chromium
        ]
        ++ optionals isLinux [
          libreoffice-qt
          vlc
        ];

      programs.signal-desktop.enable = true;
    })

  ]);
}
