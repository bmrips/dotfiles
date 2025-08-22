{
  config,
  host,
  inputs,
  lib,
  pkgs,
  user,
  ...
}:

let
  xdgConfigHome = config.home-manager.users.${user}.xdg.configHome;

  kmod-params = pkgs.writeShellApplication {
    name = "kmod-params";
    runtimeInputs = with pkgs; [
      coreutils
      fd
      gnused
      kmod
      ripgrep
    ];
    text = builtins.readFile ./kmod-params.sh;
  };

in
{
  boot = {
    initrd.systemd.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "video=efifb:nobgrt" ]; # hide the UEFI vendor logo
    loader.efi.canTouchEfiVariables = true;
    loader.efi.efiSysMountPoint = "/efi";
    plymouth.enable = true;
  };

  btrfs.mountOptions = {
    compress = "zstd";
    lazytime = true;
    rw = true;
    strictatime = true;
  };

  console = {
    earlySetup = true;
    colors = with lib.gruvbox_material.scheme "dark"; [
      base00 # background
      red
      yellow
      green
      cyan
      blue
      magenta
      base05 # foreground (white)
      base03 # gray (bright black)
      bright-red
      bright-yellow
      bright-green
      bright-cyan
      bright-blue
      bright-magenta
      base05 # foreground (bright white)
    ];
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  documentation.man = {
    generateCaches = true;
    man-db.enable = true;
  };

  environment.systemPackages = with pkgs; [
    coreutils-full
    kmod-params
    nix
    pciutils
    psmisc
    usbutils
  ];

  environment.wordlist.enable = true;

  hardware.ddcutil.enable = true;
  hardware.graphics.enable = true;
  hardware.sane.enable = true;

  i18n =
    let
      english = "en_GB.UTF-8";
      german = "de_DE.UTF-8";
    in
    {
      defaultLocale = english;
      extraLocaleSettings = {
        LC_ADDRESS = german;
        LC_CTYPE = german;
        LC_MEASUREMENT = german;
        LC_MONETARY = german;
        LC_NUMERIC = german;
        LC_PAPER = german;
        LC_TELEPHONE = german;
        LC_TIME = german;
      };
    };

  networking = {
    hostName = host;
    networkmanager.enable = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
    randomizedDelaySec = "1h";
  };

  nix.channel.enable = false;

  nix.settings = {
    auto-optimise-store = true;
    download-buffer-size = 536870912; # 512 MiB
    experimental-features = "flakes nix-command";
    trusted-users = [ user ];
    use-xdg-base-directories = true;
  };

  programs.git.config.user = {
    name = "Benedikt Rips";
    email = "benedikt.rips@gmail.com";
  };

  programs.zsh.enable = true;

  services.colord.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.fwupd.enable = true;
  services.kmscon.enable = false; # see https://github.com/NixOS/nixpkgs/issues/385497
  services.logind.powerKey = "ignore";
  services.pipewire.enable = true;
  services.printing.enable = true;
  services.resolved.enable = true;
  services.tlp.enable = true;
  services.tzupdate.enable = true;

  services.xserver.xkb = {
    layout = "us,de";
    options = "grp:shifts_toggle,eurosign:e,ctrl:swapcaps,altwin:swap_alt_win";
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/var/lib/sops/age/keys.txt";
    secrets.hashed_password.neededForUsers = true;
  };
  environment.variables.SOPS_AGE_KEY_FILE = config.sops.age.keyFile;

  system.configurationRevision =
    let
      info = inputs.self.sourceInfo;
    in
    info.shortRev or "${info.dirtyShortRev}.${info.lastModifiedDate}";

  # Ensure that `network-online.target` is only reached when the internet is
  # reachable.
  systemd.services.internet-reachable = {
    description = "Check whether the internet is reachable";
    requiredBy = [ "network-online.target" ];
    before = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.iputils}/bin/ping 8.8.8.8 -c 1";
    };
  };

  systemd.tmpfiles.settings.nixos = {
    "%C".v.age = "4 weeks"; # put the cache into a subvolume and clean it
    "/etc/nixos"."L+".argument = "${xdgConfigHome}/home-manager";
    "/mnt".d = { };
  };

  time.timeZone = lib.mkDefault "Europe/Berlin";

  users.mutableUsers = false;

  users.users.${user} = {
    isNormalUser = true;
    description = "Benedikt Rips";
    hashedPasswordFile = config.sops.secrets.hashed_password.path;
    shell = pkgs.zsh;
    uid = 1000;
  };

  virtualisation.podman.enable = true;
}
