{
  config,
  inputs,
  modulesPath,
  user,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.dell-xps-13-9360
  ];

  disko.devices.disk.main = {
    device = "/dev/disk/by-id/nvme-THNSN5256GPUK_NVMe_TOSHIBA_256GB_Y6EB70N0KMBU";
    content = {
      type = "gpt";
      partitions = {
        "EFI system" = {
          type = "EF00";
          priority = 500; # place the ESP first
          size = "1G";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [
              "dmask=0077"
              "fmask=0177"
              "nodev"
              "noexec"
              "nosuid"
            ];
          };
        };
        Swap = {
          size = "8G";
          content = {
            type = "swap";
            mountOptions = [ "nofail" ];
            randomEncryption = true;
          };
        };
        LUKS = {
          type = "8309";
          size = "100%";
          content = {
            type = "luks";
            name = "nixos";
            settings = {
              allowDiscards = true;
              crypttabExtraOpts = [
                "tpm2-device=auto"
                "tpm2-measure-pcr=yes"
              ];
            };
            content = {
              type = "btrfs";
              mountpoint = "/";
              inherit (config.btrfs) mountOptions;
              subvolumes = {
                "home" = { };
                "nix" = { };
                "var/cache" = { };
              };
            };
          };
        };
      };
    };
  };

  btrfs.mountOptions.ssd = true;

  boot = {
    initrd.availableKernelModules = [
      "aesni_intel"
      "nvme"
      "rtsx_pci_sdmmc"
      "usbhid"
      "xhci_pci"
    ];
    kernelParams = [
      "retbleed=stuff"
      "zswap.enabled=1"
    ];
    lanzaboote.enable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.devices.lacie_drive.enable = true;

  services.btrbk = {
    enable = true;
    mountPoint = "/";
  };
  services.btrfs.autoScrub.enable = true;
  services.hardware.bolt.enable = true;

  services.udev.extraRules = ''
    # turn off keyboard backlight after ten seconds
    SUBSYSTEM=="leds", KERNEL=="dell::kbd_backlight", ATTR{stop_timeout}="10"
  '';

  # This option defines the first version of NixOS you have installed on this
  # particular machine, and is used to maintain compatibility with application
  # data (e.g. databases) created on older NixOS versions.
  #
  # Do NOT change this value unless you have manually inspected all the changes
  # it would make to your configuration, and migrated your data accordingly.
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
  };

}
