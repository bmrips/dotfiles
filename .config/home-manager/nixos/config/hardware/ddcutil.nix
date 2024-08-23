{ config, lib, pkgs, user, ... }:

with lib;

let
  cfg = config.hardware.ddcutil;

  brightness = pkgs.writeShellApplication {
    name = "brightness";
    runtimeInputs = with pkgs; [ coreutils ddcutil gnugrep ];
    text = ''
      for display in $(ddcutil detect | grep '^Display ' | cut -d' ' -f2); do
          ddcutil "--display=$display" setvcp 10 "$@"
      done
    '';
  };

in {

  options.hardware.ddcutil.enable = mkEnableOption "{command}`ddcutil`";

  config = mkIf cfg.enable {
    environment.systemPackages = [ brightness pkgs.ddcutil ];
    hardware.i2c.enable = true;
    users.users."${user}".extraGroups = [ config.hardware.i2c.group ];
  };

}
