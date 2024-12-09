{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption mkPackageOption types;
  cfg = config.programs.signal-desktop;

in {

  options.programs.signal-desktop = {
    enable = mkEnableOption "Signal Desktop.";
    package = mkPackageOption pkgs "signal-desktop" { };
    autostart = mkOption {
      type = types.bool;
      default = false;
      description = "Whether Signal Desktop starts automatically on login.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    xdg.autostart.signal = mkIf cfg.autostart {
      categories = [ "Network" "InstantMessaging" "Chat" ];
      comment = "Private messaging from your desktop";
      desktopName = "Signal";
      exec = "signal-desktop --no-sandbox %U --use-tray-icon --start-in-tray";
      icon = "signal-desktop";
      mimeTypes = [ "x-scheme-handler/sgnl" "x-scheme-handler/signalcaptcha" ];
      startupWMClass = "signal";
      terminal = false;
    };
  };

}
