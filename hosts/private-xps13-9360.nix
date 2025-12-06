{
  config,
  inputs,
  modulesPath,
  user,
  ...
}:

let
  # Refer to encrypted volumes as /dev/mapper/<volume> to disable timeouts.
  # See https://github.com/NixOS/nixpkgs/issues/250003 for more information.
  swapDevice = "/dev/mapper/swap";

in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.dell-xps-13-9360
  ];

  boot.initrd = {
    availableKernelModules = [
      "aesni_intel"
      "nvme"
      "rtsx_pci_sdmmc"
      "usbhid"
      "xhci_pci"
    ];
    secrets = {
      "/root.key" = /etc/keys/root.key;
      "/swap.key" = /etc/keys/swap.key;
    };
    luks.devices = {
      root = {
        device = "/dev/disk/by-partuuid/decba6c6-fc4d-bd4c-bc14-d0dfbf1fdac8";
        keyFile = "/root.key";
        keyFileTimeout = 5;
        allowDiscards = true;
      };
      swap = {
        device = "/dev/disk/by-partuuid/30598f9b-913c-3c4e-a918-74847e068c94";
        keyFile = "/swap.key";
        keyFileTimeout = 5;
        allowDiscards = true;
        crypttabExtraOpts = [
          "plain"
          "hash=plain"
          "cipher=aes-xts-plain"
          "nofail"
        ];
      };
    };
  };

  boot.kernelParams = [
    "resume=${swapDevice}"
    "retbleed=stuff"
    "zswap.enabled=1"
  ];

  boot.loader.grub = {
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
  };

  btrfs = {
    # Refer to encrypted volumes as /dev/mapper/<volume> to disable timeouts.
    # See https://github.com/NixOS/nixpkgs/issues/250003 for more information.
    device = "/dev/mapper/root";
    mountOptions = {
      space_cache = true;
      ssd = true;
    };
    subvolumeMounts = {
      nixos = "/";
      home = "/home";
      keys = "/etc/keys";
    };
  };

  fileSystems.${config.boot.loader.efi.efiSysMountPoint} = {
    device = "/dev/disk/by-uuid/B2BD-72B9";
    fsType = "vfat";
    options = [
      "dmask=0077"
      "fmask=0177"
      "nodev"
      "noexec"
      "nosuid"
    ];
  };

  dualboot.windows.device = "/dev/disk/by-uuid/16E2EEDDE2EEBFDB";

  hardware.bluetooth.enable = true;
  hardware.devices.lacie_drive.enable = true;

  services.btrbk.enable = true;
  services.btrfs.autoScrub.enable = true;
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
  system.stateVersion = "26.05";

  home-manager.users.${user} = {
    profiles.gui.extra.enable = true;

    programs.plasma.input.touchpads = [
      {
        name = "DLL075B:01 06CB:76AF Touchpad";
        vendorId = "06CB";
        productId = "76AF";
        accelerationProfile = "default";
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
    home.stateVersion = "26.05"; # Please read the comment before changing.
  };

}
