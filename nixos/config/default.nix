{
  config,
  host,
  pkgs,
  user,
  ...
}:

let
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
  imports = [
    ./boot/plymouth.nix
    ./dualboot.nix
    ./hardware/bluetooth.nix
    ./hardware/devices/microsoft_ergonomic_keyboard.nix
    ./hardware/devices/lacie_drive.nix
    ./hardware/ddcutil.nix
    ./hardware/sane.nix
    ./networking/networkmanager.nix
    ./profiles/gui.nix
    ./programs/ausweisapp.nix
    ./programs/nitrile.nix
    ./security/sudo.nix
    ./services/desktopManager/plasma6.nix
    ./services/displayManager/sddm.nix
    ./services/kmscon.nix
    ./services/pipewire.nix
    ./services/printing.nix
    ./services/resolved.nix
    ./services/tlp.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.plymouth.enable = true;

  console = {
    earlySetup = true;
    colors = [
      "282828" # bg
      "cc241d" # red
      "98971a" # green
      "d79921" # yellow
      "458588" # blue
      "b16286" # purple
      "689d6a" # aqua
      "a89984" # fg4
      "928374" # gray
      "fb4934" # bright red
      "b8bb26" # bright green
      "fabd2f" # bright yellow
      "83a598" # bright blue
      "d3869b" # bright purple
      "8ec07c" # bright aqua
      "ebdbb2" # fg1
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

  home-manager.users.${user} = {
    profiles.linux.enable = true;

    # Compact Firefox UI.
    programs.firefox.profiles.default.settings."browser.uidensity" = 1;
  };

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
    networkmanager = {
      enable = true;
      wifi.powersave = true;
    };
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

  services.xserver.xkb = {
    layout = "us,de";
    options = "grp:shifts_toggle,eurosign:e,ctrl:swapcaps,altwin:swap_alt_win";
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "${config.home-manager.users.bmr.xdg.configHome}/sops/age/keys.txt";
    secrets.hashed_password.neededForUsers = true;
  };

  time.timeZone = "Europe/Berlin";

  users.users.${user} = {
    isNormalUser = true;
    description = "Benedikt Rips";
    hashedPasswordFile = config.sops.secrets.hashed_password.path;
    shell = pkgs.zsh;
  };

  virtualisation.podman.enable = true;
}
