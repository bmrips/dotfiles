{
  lib,
  modulesPath,
  pkgs,
  user,
  ...
}:

{
  imports = [
    "${toString modulesPath}/installer/cd-dvd/iso-image.nix"
    "${toString modulesPath}/profiles/base.nix"
  ];

  hardware.enableAllFirmware = true;
  hardware.enableAllHardware = true;
  hardware.sane.enable = lib.mkForce false;

  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;

  boot.supportedFilesystems.zfs = false;
  boot.loader.grub.memtest86.enable = true;

  # Adds terminus_font for people with HiDPI displays.
  console.packages = [ pkgs.terminus_font ];

  documentation.man.enable = true;
  documentation.doc.enable = true;

  # Prevent installation media from evacuating persistent storage, as their
  # var directory is not persistent and it would thus result in deletion of
  # those entries.
  environment.etc."systemd/pstore.conf".text = ''
    [PStore]
    Unlink=no
  '';

  # Allow log in without a password and automatically login the user.
  users.users.root.initialHashedPassword = "";
  users.users.${user} = {
    hashedPasswordFile = lib.mkForce null;
    initialHashedPassword = "";
  };
  services.getty = {
    autologinUser = user;
    helpLine = "The 'bmr' and 'root' accounts have empty passwords.";
  };
  services.displayManager.sddm.settings.Autologin = {
    Session = "plasma";
    User = user;
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    (lib.getBin qttools) # Expose qdbus in PATH
    aurorae
    baloo-widgets # baloo information in Dolphin
    elisa
    gwenview
    kate
    khelpcenter
    krdp
    xwaylandvideobridge # exposes Wayland windows to X11 screen capture
  ];

  hardware.bluetooth.enable = true;

  networking.networkmanager.enable = true;

  nix = {
    gc.automatic = lib.mkForce false;
    settings.auto-optimise-store = lib.mkForce false;
  };

  programs.ausweisapp.enable = lib.mkForce false;
  programs.kde-pim.enable = false;

  services.hardware.bolt.enable = true;
  services.fwupd.enable = lib.mkForce false;
  services.logrotate.enable = lib.mkForce false;
  services.printing.enable = lib.mkForce false;
  services.tzupdate.enable = lib.mkForce false;
  services.udisks2.enable = lib.mkForce false;

  security.sudo.wheelNeedsPassword = false;
  security.tpm2.enable = true;

  system.stateVersion = lib.trivial.release;

  virtualisation.podman.enable = lib.mkForce false;

  home-manager.users.${user} = {
    home.stateVersion = lib.trivial.release;

    accounts.email.accounts.Gmail.primary = true;

    development.bash.enable = lib.mkForce false;
    development.markdown.enable = lib.mkForce false;
    development.yaml.enable = lib.mkForce false;
    programs.keepassxc.autostart = lib.mkForce false;
    programs.kmail.enable = lib.mkForce false;
    programs.neovim.immutableConfig = lib.mkForce true;
    services.home-manager.autoExpire.enable = lib.mkForce false;
    services.owncloud-client.enable = lib.mkForce false;
  };
}
