{
  lib,
  pkgs,
  user,
  ...
}:

{
  image.modules.iso-installer = {
    boot.supportedFilesystems.zfs = false;
    installer.cloneConfig = false;
    isoImage.squashfsCompression = "zstd -Xcompression-level 3";
    system.installer.channel.enable = false;
  };

  documentation.man.enable = true;
  documentation.doc.enable = true;

  # Allow log in without a password and automatically login the user.
  users.users.root.initialHashedPassword = "";
  users.users.${user}.initialHashedPassword = "";
  services.displayManager.autoLogin.user = user;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    (lib.getBin qttools) # Expose qdbus in PATH
    aurorae
    baloo-widgets # baloo information in Dolphin
    elisa
    gwenview
    kate
    khelpcenter
    krdp
  ];

  hardware.bluetooth.enable = true;
  hardware.enableAllFirmware = true;
  hardware.sane.enable = lib.mkForce false;

  networking.networkmanager.enable = true;

  nix.gc.automatic = lib.mkForce false;
  nix.settings.auto-optimise-store = lib.mkForce false;

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

  sops.secrets = lib.mkForce { };

  system.stateVersion = lib.trivial.release;

  virtualisation.podman.enable = lib.mkForce false;

  zramSwap.enable = true;

  home-manager.users.${user} = {
    accounts.email.accounts.Gmail.primary = true;

    development.bash.enable = lib.mkForce false;
    development.markdown.enable = lib.mkForce false;
    development.yaml.enable = lib.mkForce false;

    home.file."Desktop/passwords.kdbx".source = "/home/bmr/Documents/passwords.kdbx";

    programs.kmail.enable = lib.mkForce false;
    programs.neovim.immutableConfig = lib.mkForce true;

    services.nextcloud-client.enable = lib.mkForce false;

    sops.secrets = lib.mkForce { };
  };
}
