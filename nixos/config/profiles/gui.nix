{
  config,
  lib,
  user,
  ...
}:

{
  options.profiles.gui.enable = lib.mkEnableOption "the GUI profile";

  config = lib.mkIf config.profiles.gui.enable {
    home-manager.users.${user}.profiles.gui.enable = true;
    programs.ausweisapp.enable = true;
  };
}
