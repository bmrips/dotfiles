{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.profiles.gui;
  inherit (pkgs.stdenv) hostPlatform;

in
{
  options.profiles.gui = {
    enable = lib.mkEnableOption "the GUI profile";
    extra.enable = lib.mkEnableOption "extra GUI applications";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [

      {
        programs.firefox.enable = true;
        programs.keepassxc.enable = true;
      }

      (lib.mkIf cfg.extra.enable {
        home.packages = [
          pkgs.logseq
          pkgs.spotify
        ]
        ++ lib.optionals hostPlatform.isLinux [
          pkgs.libreoffice-qt
        ];

        programs.signal-desktop.enable = true;
        programs.sioyek.enable = true;
      })

      (lib.mkIf hostPlatform.isLinux {
        home.packages = [ pkgs.wl-clipboard ];

        home.shellAliases = {
          open = "xdg-open";
          trash = "mv -t ${config.xdg.dataHome}/Trash/files";
          xc = "wl-copy";
          xp = "wl-paste";
        };

        xdg.autostart.enable = true;
      })

    ]
  );
}
