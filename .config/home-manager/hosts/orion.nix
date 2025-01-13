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
  inherit (lib) uuid partuuid;

  btrfsSubvolume = subvolume: {
    device = uuid "5c603a46-9506-4eb4-b68a-31ee0408b775";
    fsType = "btrfs";
    options = [
      "autodefrag"
      "compress=zstd:3"
      "noatime"
      "rw"
      "space_cache"
      "ssd"
      "subvol=${subvolume}"
    ];
  };

  swapDevice = uuid "a09ffe4f-168e-4b89-be3f-a0f9fbc83364";

in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.dell-xps-13-9360
  ];

  boot.initrd = {
    systemd.enable = true;
    availableKernelModules = [
      "aesni_intel"
      "nvme"
      "rtsx_pci_sdmmc"
      "usbhid"
      "xhci_pci"
    ];
    secrets = {
      "/linux.key" = /etc/keys/linux.key;
      "/swap.key" = /etc/keys/swap.key;
    };
    luks.devices = {
      linux = {
        device = partuuid "decba6c6-fc4d-bd4c-bc14-d0dfbf1fdac8";
        keyFile = "/linux.key";
      };
      swap = {
        device = partuuid "30598f9b-913c-3c4e-a918-74847e068c94";
        keyFile = "/swap.key";
        crypttabExtraOpts = [
          "plain"
          "hash=plain"
          "cipher=aes-xts-plain"
          "nofail"
        ];
      };
    };
  };

  boot.kernelModules = [ "kvm-intel" ];

  boot.kernelParams = [
    "resume=${swapDevice}"
    "retbleed=stuff"
    "video=efifb:nobgrt" # hide UEFI vendor logo
    "zswap.enabled=1"

    # For the Gen 9+ iHD graphics card, enable HuC load but disable GuC
    # submission since the latter is not available on this chip. Passing this
    # option at boot time appears to fix the overheating issue when watching
    # videos. Disable this option if you experience freezing, e.g. after
    # resuming from hibernation.
    #
    # Additionally, enable only the RC6p sleep state (other RC6 states are not
    # available on this graphics card.
    #
    # https://gist.github.com/Brainiarc7/aa43570f512906e882ad6cdd835efe57
    "i915.enable_guc=2"
    "i915.enable_dc=1"
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/efi";
    grub = {
      device = "nodev";
      efiSupport = true;
      enableCryptodisk = true;
    };
  };

  fileSystems = {
    "/" = btrfsSubvolume "nixos";
    "${config.boot.loader.efi.efiSysMountPoint}" = {
      device = uuid "B2BD-72B9";
      fsType = "vfat";
    };
    "/etc/keys" = btrfsSubvolume "keys";
    "/home" = btrfsSubvolume "home";
    "/mnt/btr_pool" = btrfsSubvolume "/";
    "/mnt/windows" = {
      device = uuid "16E2EEDDE2EEBFDB";
      fsType = "ntfs-3g";
      options = [ "noauto" ];
    };
  };

  hardware.bluetooth = {
    enable = true;
    settings.General.Experimental = true; # show battery charge of devices
  };

  hardware.cpu.intel.updateMicrocode = true;

  hardware.devices.lacie_drive.enable = true;

  services.bt-dualboot = {
    enable = true;
    mountPoint = "/mnt/windows";
  };

  services.btrbk.instances.${host}.settings.volume."/mnt/btr_pool" = {
    snapshot_dir = "btrbk_snapshots";
    target = "/mnt/lacie/backup/${host}";
    target_preserve_min = "no";
    subvolume.home = {
      snapshot_preserve_min = "2d";
      snapshot_preserve = "14d";
      target_preserve = "12w *m";
    };
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/" ];
  };

  services.hardware.bolt.enable = true;

  services.udev.extraRules = ''
    # turn off keyboard backlight after ten seconds
    SUBSYSTEM=="leds", KERNEL=="dell::kbd_backlight", ATTR{stop_timeout}="10"
  '';

  swapDevices = [ { device = swapDevice; } ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05";

  home-manager.users.${user} = {
    profiles.gui.extra.enable = true;
    profiles.uni-muenster.enable = true;

    # The device's name.
    programs.firefox.profiles.default.settings = {
      "identity.fxaccounts.account.device.name" = host;
    };

    programs.plasma.input.touchpads = [
      {
        name = "DLL075B:01 06CB:76AF Touchpad";
        vendorId = "1739";
        productId = "30383";
        disableWhileTyping = true;
        naturalScroll = true;
        pointerSpeed = 0.0;
        rightClickMethod = "twoFingers";
        scrollMethod = "twoFingers";
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
    home.stateVersion = "23.11"; # Please read the comment before changing.
  };

}
