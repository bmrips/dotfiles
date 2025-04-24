{
  config,
  host,
  inputs,
  lib,
  modulesPath,
  user,
  ...
}:

let
  btrfsSubvolume = subvolume: {
    # Refer to encrypted volumes as /dev/mapper/<volume> to disable timeouts.
    # See https://github.com/NixOS/nixpkgs/issues/250003 for more information.
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [
      "autodefrag"
      "compress=zstd:3"
      "lazytime"
      "rw"
      "ssd"
      "strictatime"
      "subvol=${subvolume}"
    ];
  };

in
{

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-cpu-intel
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/efi";
    systemd-boot.enable = true;
  };

  boot.kernelParams = [
    "video=efifb:nobgrt" # hide UEFI vendor logo
  ];

  boot.initrd = {
    systemd.enable = true;
    availableKernelModules = [
      "aesni_intel"
      "nvme"
      "sd_mod"
      "thunderbolt"
      "usb_storage"
      "vmd"
      "xhci_pci"
    ];
    luks.devices.root = {
      device = lib.uuid "256d1efd-5e12-4caf-8e1c-9b51c41f46c4";
      keyFile = "/dev/sda";
      keyFileSize = 256;
      keyFileTimeout = 5;
      allowDiscards = true;
    };
  };

  fileSystems = {
    "/" = btrfsSubvolume "nixos";
    "/home" = btrfsSubvolume "home";
    "${config.boot.loader.efi.efiSysMountPoint}" = {
      device = lib.uuid "12CE-A600";
      fsType = "vfat";
    };
  };

  dualboot.windows.uuid = "CAE4531BE45308D9";

  hardware.bluetooth.enable = true;
  hardware.devices.lacie_drive.enable = true;
  hardware.intelgpu = {
    driver = "xe";
    vaapiDriver = "intel-media-driver";
  };

  hardware.nvidia = {
    open = true;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };
  services.xserver.videoDrivers = [
    "intel"
    "nvidia"
  ];

  fileSystems."/mnt/btr_pool" = btrfsSubvolume "/";
  services.btrbk.instances.${host}.settings.volume."/mnt/btr_pool" = {
    snapshot_dir = "btrbk_snapshots";
    target = "/mnt/lacie/backup/${host}";
    subvolume.home = {
      snapshot_preserve_min = "2d";
      snapshot_preserve = "14d";
      target_preserve_min = "no";
      target_preserve = "12w *m";
    };
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/" ];
  };

  services.hardware.bolt.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11";

  programs.nitrile.enable = true;

  home-manager.users.${user} = {
    profiles.radboud.enable = true;

    programs.plasma.input.touchpads = [
      {
        name = "VEN_06CB:00 06CB:CEEC Touchpad";
        vendorId = "06CB";
        productId = "CEEC";
        accelerationProfile = "default";
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
