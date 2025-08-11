{
  config,
  lib,
  pkgs,
  user,
  ...
}:

let
  brightness = pkgs.writeShellApplication {
    name = "brightness";
    runtimeInputs = with pkgs; [
      coreutils
      ddcutil
      gnugrep
    ];
    text = ''
      for display in $(ddcutil detect | grep '^Display ' | cut -d' ' -f2); do
          ddcutil "--display=$display" setvcp 10 "$@"
      done
    '';
  };

in
{

  options.hardware.ddcutil.enable = lib.mkEnableOption "{command}`ddcutil`";

  config = lib.mkIf config.hardware.ddcutil.enable {
    environment.systemPackages = [
      brightness
      pkgs.ddcutil
    ];
    hardware.i2c.enable = true;
    users.users.${user}.extraGroups = [ config.hardware.i2c.group ];

    home-manager.users.${user}.programs.plasma.hotkeys.commands = {
      decrease-screen-brightness = {
        name = "Decrease screen brightness";
        command = "brightness - 10";
        key = "Meta+Shift+PgDown";
      };
      increase-screen-brightness = {
        name = "Increase screen brightness";
        command = "brightness + 10";
        key = "Meta+Shift+PgUp";
      };
    };
  };

}
