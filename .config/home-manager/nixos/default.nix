{ host, lib, pkgs, user, ... }:

let
  kmod-params = pkgs.writeShellApplication {
    name = "kmod-params";
    runtimeInputs = with pkgs; [ coreutils fd gnused kmod ripgrep ];
    excludeShellChecks = [ "SC2059" ];
    text = builtins.readFile ./kmod-params.sh;
  };

in {
  imports = [
    ./boot/plymouth.nix
    ./hardware/ddcutil.nix
    ./hardware/sane.nix
    ./networking/networkmanager.nix
    ./profiles/gui.nix
    ./programs/ausweisapp.nix
    ./security/sudo.nix
    ./services/desktopManager/plasma6.nix
    ./services/displayManager/sddm.nix
    ./services/kmscon.nix
    ./services/pipewire.nix
    ./services/printing.nix
    ./services/tlp.nix
  ];

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
    psmisc
  ];

  hardware.ddcutil.enable = true;

  hardware.sane.enable = true;

  home-manager.users."${user}".profiles.linux.enable = true;

  i18n = let
    english = "en_GB.UTF-8";
    german = "de_DE.UTF-8";
  in {
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
    useDHCP = lib.mkDefault true;
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

  nix.settings = {
    auto-optimise-store = true;
    use-xdg-base-directories = true;
  };

  nixpkgs.config = {
    allowAliases = false;
    allowUnfree = true;
    checkMeta = true;
    warnUndeclaredOptions = true;
  };

  programs.zsh.enable = true;

  services.colord.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.kmscon.enable = true;
  services.logind.powerKey = "ignore";
  services.pipewire.enable = true;
  services.printing.enable = true;
  services.tlp.enable = true;

  services.udev.extraHwdb = ''
    # on the Microsoft Natural Ergonomic Keyboard 4000, the zoom slider scrolls
    evdev:input:b0003v045Ep00DB*
     KEYBOARD_KEY_c022d=pageup   # zoomin
     KEYBOARD_KEY_c022e=pagedown # zoomout
  '';

  services.xserver.xkb = {
    layout = "us,de";
    options = "grp:shifts_toggle,eurosign:e,ctrl:swapcaps,altwin:swap_alt_win";
  };

  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    randomizedDelaySec = "1h";
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05";

  time.timeZone = "Europe/Berlin";

  users.users."${user}" = {
    isNormalUser = true;
    description = "Benedikt Rips";
    shell = pkgs.zsh;
  };

  virtualisation.podman.enable = true;
}
