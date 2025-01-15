{
  config,
  lib,
  host,
  user,
  ...
}:

{
  options.profiles.gui.enable = lib.mkEnableOption "the GUI profile";

  config = lib.mkIf config.profiles.gui.enable {
    home-manager.users.${user} = {
      profiles.gui.enable = true;
      programs.firefox.profiles.default.settings = {
        "identity.fxaccounts.account.device.name" = host;
      };
    };
    programs.ausweisapp.enable = true;
  };
}
