{
  config,
  lib,
  modulesPath,
  user,
  ...
}:

let
  btrfsSubvolume = subvolume: {
    device = lib.uuid "4c9faf53-86ad-411e-a6a9-adc39994aac4";
    fsType = "btrfs";
    options = [
      "autodefrag"
      "compress=zstd:3"
      "noatime"
      "rw"
      "ssd"
      "subvol=${subvolume}"
    ];
  };

in
{

  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/efi";
    systemd-boot.enable = true;
  };

  boot.kernelModules = [ "kvm-intel" ];

  boot.kernelParams = [
    "video=efifb:nobgrt" # hide UEFI vendor logo
  ];

  boot.initrd = {
    systemd.enable = true;
    availableKernelModules = [
      "nvme"
      "sd_mod"
      "thunderbolt"
      "usb_storage"
      "vmd"
      "xhci_pci"
    ];
    luks.devices.linux.device = "/dev/disk/by-uuid/256d1efd-5e12-4caf-8e1c-9b51c41f46c4";
  };

  fileSystems = {
    "/" = btrfsSubvolume "nixos";
    "/home" = btrfsSubvolume "home";
    "${config.boot.loader.efi.efiSysMountPoint}" = {
      device = lib.uuid "12CE-A600";
      fsType = "vfat";
    };
    "/mnt/windows" = {
      device = lib.uuid "CAE4531BE45308D9";
      fsType = "ntfs-3g";
      options = [ "noauto" ];
    };
  };

  hardware.bluetooth = {
    enable = true;
    settings.General.Experimental = true; # show battery charge of devices
  };

  hardware.cpu.intel.updateMicrocode = true;

  hardware.nvidia.open = true;
  services.xserver.videoDrivers = [
    "intel"
    "nvidia"
  ];

  services.bt-dualboot = {
    enable = true;
    mountPoint = "/mnt/windows";
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/" ];
  };

  services.hardware.bolt.enable = true;

  system.stateVersion = "24.11";

  programs.nitrile.enable = true;

  home-manager.users.${user} = {
    profiles.radboud.enable = true;

    programs.plasma.input.touchpads = [
      {
        name = "VEN_06CB:00 06CB:CEEC Touchpad";
        vendorId = "1739";
        productId = "52972";
        disableWhileTyping = true;
        naturalScroll = true;
        pointerSpeed = 0.0;
        rightClickMethod = "twoFingers";
        scrollMethod = "twoFingers";
        scrollSpeed = 1.0;
        tapAndDrag = true;
        tapToClick = true;
        twoFingerTap = "rightClick";
      }
    ];

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "24.11"; # Please read the comment before changing.
  };

}
