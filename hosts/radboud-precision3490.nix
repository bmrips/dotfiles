{
  config,
  inputs,
  lib,
  modulesPath,
  user,
  ...
}:

{

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.dell-precision-3490-nvidia
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia
  ];

  boot.kernelParams = [ "retbleed=stuff" ];

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  boot.initrd = {
    availableKernelModules = [ "aesni_intel" ];
    luks.devices.nixos = {
      device = "/dev/disk/by-uuid/256d1efd-5e12-4caf-8e1c-9b51c41f46c4";
      allowDiscards = true;
      crypttabExtraOpts = [
        "tpm2-device=auto"
        "tpm2-measure-pcr=yes"
      ];
    };
  };

  # Refer to encrypted volumes as /dev/mapper/<volume> to disable timeouts.
  # See https://github.com/NixOS/nixpkgs/issues/250003 for more information.
  impermanence.enable = true;
  btrfs.device = "/dev/mapper/nixos";
  btrfs.mountOptions.ssd = true;

  fileSystems."${config.boot.loader.efi.efiSysMountPoint}" = {
    device = "/dev/disk/by-uuid/12CE-A600";
    fsType = "vfat";
  };

  dualboot.windows.device = "/dev/disk/by-uuid/CAE4531BE45308D9";

  hardware.bluetooth.enable = true;
  hardware.devices.lacie_drive.enable = true;

  profiles.radboud.enable = true;

  security.tpm2.enable = true;

  services.btrbk.enable = true;
  services.btrfs.autoScrub.enable = true;
  services.hardware.bolt.enable = true;

  zramSwap.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11";

  home-manager.users.${user} = {
    programs.keepassxc = {
      autounlock = true;
      settings.SSHAgent.Enabled = lib.mkForce false; # use TPM-sealed keys instead
    };

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
