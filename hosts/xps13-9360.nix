{
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

  disko = {
    enable = true;
    devices.disk.main = {
      device = "/dev/disk/by-id/nvme-THNSN5256GPUK_NVMe_TOSHIBA_256GB_Y6EB70N0KMBU";
      content.partitions = {
        Swap.size = "8G";
        LUKS.content.content.mountOptions = [ "ssd" ];
      };
    };
  };

  boot = {
    initrd.availableKernelModules = [
      "aesni_intel"
      "nvme"
      "rtsx_pci_sdmmc"
      "usbhid"
      "xhci_pci"
    ];
    kernelParams = [ "retbleed=stuff" ];
    lanzaboote.enable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.devices.lacie_drive.enable = true;

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
  system.stateVersion = "26.11";

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
