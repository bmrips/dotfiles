{
  inputs,
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

  disko = {
    enable = true;
    devices.disk.main = {
      device = "/dev/disk/by-id/nvme-BG6_KIOXIA_1024GB_7E3CTA9NZ16G";
      content.partitions = {
        "DELL support" = {
          priority = 200;
          size = "1493M";
        };
        Swap.size = "32G";
        LUKS.content.content.mountOptions = [ "ssd" ];
      };
    };
  };

  boot = {
    initrd.availableKernelModules = [ "aesni_intel" ];
    kernelParams = [ "retbleed=stuff" ];
    lanzaboote.enable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.devices.lacie_drive.enable = true;

  profiles.radboud.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  services.hardware.bolt.enable = true;
  services.languagetool.enable = true;

  # This option defines the first version of NixOS you have installed on this
  # particular machine, and is used to maintain compatibility with application
  # data (e.g. databases) created on older NixOS versions.
  #
  # Do NOT change this value unless you have manually inspected all the changes
  # it would make to your configuration, and migrated your data accordingly.
  system.stateVersion = "26.11";

  home-manager.users.${user}.programs.plasma.input.touchpads = [
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

}
