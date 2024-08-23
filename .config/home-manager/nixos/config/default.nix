{ host, lib, pkgs, user, ... }:

{
  imports = [
    hardware/ddcutil.nix
    hardware/sane.nix
    networking/networkmanager.nix
    security/sudo.nix
    services/kmscon.nix
    services/pipewire.nix
    services/printing.nix
    services/tlp.nix
  ];

  nix.settings = {
    auto-optimise-store = true;
    use-xdg-base-directories = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
    randomizedDelaySec = "1h";
  };

  nixpkgs.config = {
    allowAliases = false;
    allowUnfree = true;
    checkMeta = true;
    warnUndeclaredOptions = true;
  };

  # Whether the installation process is allowed to modify EFI boot variables.
  # boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [ "quiet" ];
  boot.plymouth = {
    enable = true;
    theme = "breeze";
    logo =
      "${pkgs.nixos-icons}/share/icons/hicolor/64x64/apps/nix-snowflake-white.png";
  };

  networking.hostName = host;
  networking.useDHCP = lib.mkDefault true;

  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
    ensureProfiles.profiles = {
      home = {
        connection = {
          id = "Home";
          uuid = "ba58bd83-b999-4c98-8946-4c29a6c83a6a";
          type = "wifi";
          permissions = "user:${user}:;";
        };
        wifi = {
          mode = "infrastructure";
          ssid = "in omnia paratus";
        };
        wifi-security = {
          key-mgmt = "sae";
          psk-flags = "1";
        };
        ipv4.method = "auto";
        ipv6 = {
          addr-gen-mode = "stable-privacy";
          method = "auto";
        };
      };
      uni-muenster = {
        connection = {
          id = "Uni Münster";
          uuid = "0a5feb3b-73c5-47bb-92e4-8d3915e4f3b3";
          type = "vpn";
          permissions = "user:${user}:;";
        };
        vpn = {
          cookie-flags = "2";
          enable_csd_trojan = "no";
          "form:main:password-flags" = "2";
          "form:main:secondary_password-flags" = "2";
          gateway = "vpn.uni-muenster.de";
          gateway-flags = "2";
          gwcert-flags = "2";
          pem_passphrase_fsid = "no";
          prevent_invalid_cert = "no";
          protocol = "anyconnect";
          reported_os = "";
          stoken_source = "disabled";
          stoken_string-flags = "1";
          service-type = "org.freedesktop.NetworkManager.openconnect";
        };
        ipv4.method = "auto";
        ipv6 = {
          addr-gen-mode = "default";
          method = "auto";
        };
      };
    };
  };

  time.timeZone = "Europe/Berlin";

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

  fonts.jetbrains-mono = {
    enable = true;
    package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
    asDefaultMonospacedFont = "JetbrainsMono NF Medium";
  };

  documentation.man = {
    generateCaches = true;
    man-db.enable = true;
  };

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

  services.logind.powerKey = "ignore";

  services.kmscon.enable = true;

  services.displayManager.sddm.enable = true;
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us,de";
      options =
        "grp:shifts_toggle,eurosign:e,ctrl:swapcaps,altwin:swap_alt_win";
    };
  };

  services.desktopManager.plasma6.enable = true;

  services.colord.enable = true;

  services.printing.enable = true;

  services.pipewire.enable = true;

  services.udev.extraHwdb = ''
    # on the Microsoft Natural Ergonomic Keyboard 4000, the zoom slider scrolls
    evdev:input:b0003v045Ep00DB*
     KEYBOARD_KEY_c022d=pageup   # zoomin
     KEYBOARD_KEY_c022e=pagedown # zoomout
  '';

  services.tlp.enable = true;

  hardware.ddcutil.enable = true;

  hardware.sane.enable = true;

  virtualisation.podman.enable = true;

  environment = {
    shellAliases = {
      chgrp = "chgrp --preserve-root";
      chmod = "chmod --preserve-root";
      chown = "chown --preserve-root";
      cp = "cp --interactive";
      df = "df --human-readable";
      diff = "diff --color=auto";
      dmesg = "dmesg --color=auto";
      du = "diff --human-readable";
      free = "free --human";
      grep = "grep --binary-files=without-match --color=auto";
      ip = "ip -color=auto";
      ls = "ls --human-readable --color=auto --time-style=long-iso --literal";
      mv = "mv --interactive";
      open = "xdg-open";
      rm = "rm --preserve-root";
    };
    localBinInPath = true;
    variables = {
      LESS = lib.strings.concatStringsSep " " [
        "--LONG-PROMPT"
        "--RAW-CONTROL-CHARS"
        "--quiet"
        "--quit-if-one-screen"
        "--wheel-lines=3"
      ];
      XDG_BIN_HOME = "$HOME/.local/bin";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };
  };

  environment.systemPackages = with pkgs; [
    bash
    bash-completion
    bat
    coreutils-full
    delta
    diff-so-fancy
    diffutils
    direnv
    dos2unix
    fd
    file
    findutils
    fzf
    git
    gitlint
    gnugrep
    gnupg
    gnused
    # goto
    ncdu
    nil
    nix
    nix-bash-completions
    nixfmt-classic
    # nixpkgs_23_05.taskell
    pre-commit
    # python3Packages.cdhist
    psmisc
    ripgrep
    stylua
    tree
    wl-clipboard
    zsh-nix-shell
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    histFile = "$XDG_STATE_HOME/zsh/history";
    setOptions = [
      "extended_history" # save timestamps and duration
      "hist_reduce_blanks" # remove superfluous blanks
      "inc_append_history" # share history between zsh instances
      "sh_word_split" # split fields like in Bash
    ];
    interactiveShellInit = ''
      source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh

      mkdir --parents "$XDG_CACHE_HOME/zsh" "$XDG_STATE_HOME/zsh"

      _comp_option+=(globdots)  # include hidden files in completion
      zstyle ':completion:*' menu select  # enable menu style completion
      zstyle ':completion:*' verbose yes
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS} # colorized completion
      zstyle ':completion:*' keep-prefix yes  # keep a prefix containing ~ or a param

      alias -g NE='2>/dev/null'
      alias -g NO='&>/dev/null'

      bindkey '^E' forward-word  # complete next word from autosuggestion
    '';
  };

  programs.starship.enable = true;

  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };

  users.defaultUserShell = pkgs.zsh;

  users.users."${user}" = {
    isNormalUser = true;
    description = "Benedikt Rips";
    shell = pkgs.zsh;
  };

  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    randomizedDelaySec = "1h";
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
