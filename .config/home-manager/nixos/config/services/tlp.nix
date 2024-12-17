{ config, lib, ... }:

{
  # conflicts with TLP
  services.power-profiles-daemon.enable =
    lib.mkIf config.services.tlp.enable false;

  services.tlp.settings = {
    CPU_BOOST_ON_AC = 1;
    CPU_BOOST_ON_BAT = 0;
    CPU_HWP_DYN_BOOST_ON_AC = 1;
    CPU_HWP_DYN_BOOST_ON_BAT = 0;
    DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = "bluetooth nfc wifi wwan";
  };
}
