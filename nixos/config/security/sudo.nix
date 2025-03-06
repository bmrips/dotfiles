{
  config,
  lib,
  user,
  ...
}:

{
  security.sudo.extraConfig = ''
    # at the password request, display input as asterisks
    Defaults pwfeedback

    # grant access to my SSH and GPG agents
    Defaults:${user} env_keep += "XDG_RUNTIME_DIR"

    # forward Konsole profile information
    Defaults:${user} env_keep += "TERM COLORTERM BACKGROUND FONT_SIZE"

    # enable the clipboard
    Defaults:${user} env_keep += "WAYLAND_DISPLAY"

    # do not lecture me
    Defaults:${user} lecture = never
  '';

  users.users.${user}.extraGroups = lib.mkIf config.security.sudo.enable [ "wheel" ];
}
