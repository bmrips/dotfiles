{ config, lib, ... }:

{
  programs.signal-desktop = {
    autostart = true;
    config = {
      mediaPermissions = true;
      mediaCameraPermissions = true;
    };
    ephemeralConfig = {
      system-tray-setting = "MinimizeToAndStartInSystemTray";
      window.autoHideMenuBar = true;
    };
  };

  programs.plasma.window-rules = lib.mkIf config.programs.signal-desktop.enable [
    {
      description = "Signal";
      match.window-class = {
        match-whole = false;
        value = "signal";
      };
      apply = {
        maximizehoriz = false;
        maximizevert = false;
        placement.apply = "force";
        placement.value = 5;
        size.value = "780,556";
      };
    }
  ];
}
