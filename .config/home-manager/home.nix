{ config, lib, pkgs, ... }:

with lib;

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

  gnuCommandArgs = cli.toGNUCommandLine { };
  gnuCommandLine = attrs: concatStringsSep " " (gnuCommandArgs attrs);

  store = path: "${path}";

  nixpkgs_23_05 = import (fetchTarball {
    name = "nixpks-23.05-darwin-20231231";
    url =
      "https://github.com/NixOS/nixpkgs/archive/2c9c58e98243930f8cb70387934daa4bc8b00373.tar.gz";
    sha256 = "0mk8p5sr5b507q4045ssrjmc4rghkfxa1fzr25idj2z9gbyf1f3s";
  }) { };

  packageSets = {
    core = with pkgs; [
      checkbashisms
      coreutils-full
      diffutils
      dockerfile-language-server-nodejs
      dos2unix
      fd
      file
      findutils
      gitlint
      gnumake # for markdown-preview.nvim
      gnused
      ltex-ls
      lua-language-server
      man-db
      markdownlint-cli
      marksman
      ncdu
      (nerdfonts.override {
        fonts = [
          # "Hasklig"
          "JetBrainsMono"
        ];
      })
      nil
      nix-bash-completions
      nix-zsh-completions
      nixfmt-classic
      nodejs # for markdown-preview.nvim
      nodePackages.bash-language-server
      podman
      pre-commit
      python3Packages.mdformat
      python3Packages.mdformat-footnote
      python3Packages.mdformat-gfm
      python3Packages.mdformat-tables
      selene
      shfmt
      stylua
      tokei
      tree
      tree-sitter
      yamlfmt
    ];
    extra = with pkgs; [
      cbfmt
      difftastic
      eza
      gfold
      git-cliff
      # git-latexdiff # conflicts with texlive
      gitui
      glow
      gum
      ocrmypdf
      onefetch
      nixpkgs_23_05.haskellPackages.friendly
      ripgrep-all
      rmlint
      sad
      sd
      thefuck
      translate-shell
      treefmt
      yaml-language-server
    ];
    gui = with pkgs; [ keepassxc spotify ];
    macos = with pkgs; [ iterm2 rectangle unnaturalscrollwheels ];
    tex = with pkgs; [ texlab texliveFull ];
  };

  locales = {
    english = "en_GB.UTF-8";
    german = "de_DE.UTF-8";
  };

  dirPreview = let
    lsArgs = gnuCommandLine {
      color = true;
      group-directories-first = true;
      human-readable = true;
      l = true;
      literal = true;
      time-style = "+t";
    };
  in dir:
  escapeShellArg
  "ls ${lsArgs} ${dir} | cut --delimiter=' ' --fields=1,5- | sed 's/ t / /' | tail -n+2";

  filePreviewArgs = {
    plain = true;
    color = "always";
    paging = "never";
  };

  fzf-state-keybindings = reloadCmd:
    escapeShellArg (concatStringsSep "," [
      "alt-h:execute(fzf-state toggle hide-hidden-files)+reload(${reloadCmd})"
      "alt-i:execute(fzf-state toggle show-ignored-files)+reload(${reloadCmd})"
    ]);

  # Read Nix's initialisation script here to survive macOS system updates.
  readNixInitScript = ''
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  '';

  gitWrapper = ''
    if [[ -n $1 && $1 == "cd-root" ]]; then
        declare -r top_level="$(command git rev-parse --show-toplevel)" &&
          cd "$top_level"
    else
        command git "$@"
    fi
  '';

  mkcd = ''mkdir --parents "$1" && cd "$1"'';

  initExtra = ''
    # Path and directory completion, e.g. for `cd .config/**`
    _fzf_compgen_path() {
        ${config.programs.fd.package}/bin/fd --follow --hidden --exclude=".git" . "$1"
    }
    _fzf_compgen_dir() {
        ${config.programs.fd.package}/bin/fd --follow --hidden --exclude=".git" --type=directory . "$1"
    }

    # use ASCII arrow head in non-pseudo TTYs
    if [[ $TTY == /dev/${if isDarwin then "console" else "tty*"} ]]; then
        export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --marker='>' --pointer='>' --prompt='> '"
    fi
  '';

in {
  imports = [
    ./modules/cdhist.nix
    ./modules/fzf-tab-completion.nix
    ./modules/gcc.nix
    ./modules/goto.nix
    ./modules/grep.nix
    ./modules/less.nix
    ./modules/nix.nix
    ./modules/shellcheck.nix
    ./modules/taskell.nix
    ./modules/zsh.nix
  ];

  programs.home-manager.enable = true;

  home.username = "bmr";
  home.homeDirectory = if isDarwin then
    "/Users/${config.home.username}"
  else
    "/home/${config.home.username}";

  nix = {
    package = pkgs.nix;
    path = [ "${config.xdg.stateHome}/nix/defexpr/channels" ];
    settings = {
      auto-optimise-store = true;
      experimental-features = "flakes nix-command";
      use-xdg-base-directories = true;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };

  xdg.enable = true;
  xdg.userDirs.enable = isLinux;

  i18n.glibcLocales = pkgs.glibcLocales.override {
    allLocales = false;
    locales = with locales; builtins.map (l: l + "/UTF-8") [ english german ];
  };

  home.language = with locales; {
    base = english;
    address = german;
    ctype = german;
    measurement = german;
    monetary = german;
    numeric = german;
    paper = german;
    telephone = german;
    time = german;
  };

  home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

  home.sessionVariables = let subshell = cmd: ''\"\$(${cmd})\"'';
  in rec {
    FZF_COMPLETION_OPTS = gnuCommandLine { height = "80%"; };
    FZF_GOTO_OPTS = gnuCommandLine {
      preview = dirPreview (subshell "echo {} | sed 's/^[a-zA-Z]* *//'");
    };
    FZF_CDHIST_OPTS = gnuCommandLine {
      preview = dirPreview (subshell
        "echo {} | ${pkgs.gnused}/bin/sed 's#^~#${config.home.homeDirectory}#'");
    };
    FZF_GREP_COMMAND = "fzf-state get-source grep";
    FZF_GREP_OPTS = let
      batArgs = gnuCommandLine (filePreviewArgs // {
        line-range = subshell "fzf-state context {2}: --highlight-line={2} {1}";
      });
    in gnuCommandLine {
      bind = fzf-state-keybindings "${FZF_GREP_COMMAND} {q}";
      multi = true;
      preview =
        escapeShellArg "${config.programs.bat.package}/bin/bat ${batArgs} {1}";
    };
    TEXEDIT = "${config.home.sessionVariables.EDITOR} +%d %s";
    YAMLLINT_CONFIG_FILE = "${config.xdg.configHome}/yamllint.yaml";
  };

  home.shellAliases = let
    settings = mapAttrs (prog: opts: "${prog} ${gnuCommandLine opts}") {
      chgrp.preserve-root = true;
      chmod.preserve-root = true;
      chown.preserve-root = true;
      cp.interactive = true;
      df.human-readable = true;
      diff.color = "auto";
      dmesg.color = "auto";
      du.human-readable = true;
      free.human = true;
      grep.binary-files = "without-match";
      grep.color = "auto";
      ls = {
        color = true;
        group-directories-first = true;
        human-readable = true;
        literal = true;
        time-style = "long-iso";
      };
      make.jobs = 4;
      mv.interactive = true;
      onefetch = {
        include-hidden = true;
        no-art = true;
        no-bots = true;
        no-color-palette = true;
        no-title = true;
        true-color = "never";
      };
      rm.preserve-root = true;
      stylua.search-parent-directories = true;
      tree.C = true; # always colorise output
      tree.dirsfirst = true;
      wget.continue = true;
    };
  in settings // {
    ip = "ip -color=auto";
    nvim = "TTY=$TTY nvim";

    b = "goto";
    c = "cd";
    g = "git";
    gl = "glab";
    hm = "home-manager";
    k = "kubectl";
    l = "ll";
    "l." = "ld .*";
    la = "ll -A";
    ld = "ll -d";
    ll = "ls -l";
    "ls." = "lsd .*";
    lsd = "ls -d";
    lsx = "ls -X";
    lx = "ll -X";
    o = "open";
    p = "podman";
    t = "tree --gitignore";
    v = "nvim";
    vi = "nvim";
    vim = "nvim";
    xc = if isDarwin then "pbcopy" else "wl-copy";
    xp = if isDarwin then "pbpaste" else "wl-paste";
  } // optionalAttrs isLinux {
    open = "xdg-open";
    trash = "mv -t ${config.xdg.dataHome}/Trash/files";
  };

  fonts.fontconfig.enable = true;

  programs.bash = {
    enable = true;
    profileExtra = mkIf isDarwin readNixInitScript;
    historyControl = [ "ignoredups" ];
    historyFile = "${config.xdg.stateHome}/bash/history";
    initExtra = ''
      ${initExtra}

      function git() {
        ${gitWrapper}
      }

      function mkcd() {
        ${mkcd}
      }
    '';
  };

  programs.bat = {
    enable = true;
    config = {
      italic-text = "always";
      plain = true;
      theme = "base16";
    };
  };

  programs.cdhist.enable = true;

  programs.dircolors = {
    enable = true;
    settings = {
      "NORMAL" = "00"; # normal text
      "RESET" = "00"; # reset to "normal" color

      # File type
      "FILE" = "00";
      "DIR" = "94";
      "LINK" = "96";
      "ORPHAN" = "91"; # symlink to nonexistent file
      "MISSING" = "31;07"; # a nonexistent target of a symlink
      "MULTIHARDLINK" = "00"; # regular file with more than one link
      "FIFO" = "93"; # pipe
      "SOCK" = "95";
      "DOOR" = "95";
      "BLK" = "93"; # block device
      "CHR" = "93"; # character device

      # Permissions
      "EXEC" = "92";
      "SETUID" = "31;07";
      "SETGID" = "33;07";
      "CAPABILITY" = "31;07";
      "STICKY_OTHER_WRITABLE" = "34;07";
      "OTHER_WRITABLE" = "36;07";
      "STICKY" = "35;07";

      # Archives
      ".7z" = "91";
      ".ace" = "91";
      ".alz" = "91";
      ".arc" = "91";
      ".arj" = "91";
      ".bz" = "91";
      ".bz2" = "91";
      ".cab" = "91";
      ".cpio" = "91";
      ".deb" = "91";
      ".dwm" = "91";
      ".dz" = "91";
      ".ear" = "91";
      ".esd" = "91";
      ".gz" = "91";
      ".jar" = "91";
      ".lha" = "91";
      ".lrz" = "91";
      ".lz" = "91";
      ".lz4" = "91";
      ".lzh" = "91";
      ".lzma" = "91";
      ".lzo" = "91";
      ".rar" = "91";
      ".rpm" = "91";
      ".rz" = "91";
      ".sar" = "91";
      ".swm" = "91";
      ".t7z" = "91";
      ".tar" = "91";
      ".taz" = "91";
      ".tbz" = "91";
      ".tbz2" = "91";
      ".tgz" = "91";
      ".tlz" = "91";
      ".txz" = "91";
      ".tz" = "91";
      ".tzo" = "91";
      ".tzst" = "91";
      ".war" = "91";
      ".wim" = "91";
      ".xz" = "91";
      ".z" = "91";
      ".Z" = "91";
      ".zip" = "91";
      ".zoo" = "91";
      ".zst" = "91";

      # Images
      ".asf" = "95";
      ".avi" = "95";
      ".bmp" = "95";
      ".cgm" = "95";
      ".dl" = "95";
      ".emf" = "95";
      ".flc" = "95";
      ".fli" = "95";
      ".flv" = "95";
      ".gif" = "95";
      ".gl" = "95";
      ".jpeg" = "95";
      ".jpg" = "95";
      ".m2v" = "95";
      ".m4v" = "95";
      ".mjpeg" = "95";
      ".mjpg" = "95";
      ".mkv" = "95";
      ".mng" = "95";
      ".mov" = "95";
      ".mp4" = "95";
      ".mp4v" = "95";
      ".mpeg" = "95";
      ".mpg" = "95";
      ".nuv" = "95";
      ".ogm" = "95";
      ".pbm" = "95";
      ".pcx" = "95";
      ".pgm" = "95";
      ".png" = "95";
      ".ppm" = "95";
      ".qt" = "95";
      ".rm" = "95";
      ".rmvb" = "95";
      ".svg" = "95";
      ".svgz" = "95";
      ".tga" = "95";
      ".tif" = "95";
      ".tiff" = "95";
      ".vob" = "95";
      ".webm" = "95";
      ".wmv" = "95";
      ".xbm" = "95";
      ".xcf" = "95";
      ".xpm" = "95";
      ".xwd" = "95";
      ".yuv" = "95";

      # Audio
      ".aac" = "95";
      ".au" = "95";
      ".flac" = "95";
      ".m4a" = "95";
      ".mid" = "95";
      ".midi" = "95";
      ".mka" = "95";
      ".mp3" = "95";
      ".mpc" = "95";
      ".oga" = "95";
      ".ogg" = "95";
      ".ogv" = "95";
      ".ogx" = "95";
      ".opus" = "95";
      ".ra" = "95";
      ".spx" = "95";
      ".wav" = "95";
      ".xspf" = "95";

      # Documents
      ".md" = "33";
      ".markdown" = "33";
      ".pdf" = "35";

      # Version control
      ".gitattributes" = "90";
      ".gitignore" = "90";
      ".gitmodules" = "90";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config.global.hide_env_diff = true;
  };

  programs.firefox = {
    enable = true;
    package = mkIf isDarwin null;
    nativeMessagingHosts =
      optional isLinux pkgs.kdePackages.plasma-browser-integration;
    policies = {
      PrimaryPassword = true;
      SearchBar = "unified";
    };
    profiles.default = {
      settings = {
        # Do not warn when visiting about:config.
        "browser.aboutConfig.showWarning" = false;

        # Restore the last session.
        "browser.startup.page" = 3;

        # Warn when quitting multiple windows.
        "browser.sessionstore.warnOnQuit" = true;

        # Disable accessibility.
        "acessibility.force_disabled" = true;

        # Enable automatic scrolling.
        "general.autoscroll" = true;

        # Do not check whether Firefox is the default browser.
        "browser.shell.checkDefaultBrowser" = true;

        # The device's name.
        "identity.fxaccounts.account.device.name" = "orion";

        # Configure synchronisation.
        "services.sync.username" = "benedikt.rips@gmail.com";

        # Website appearance matches the system theme.
        "browser.display.use_system_colors" = true;

        # Separate titlebar.
        "browser.tabs.inTitlebar" = if isLinux then 0 else 2;

        # Do not create default bookmarks.
        "browser.bookmarks.restore_default_bookmarks" = false;

        # Never show the bookmarks and menu toolbar.
        "browser.toolbars.bookmarks.visibility" = "never";
        "ui.key.menuAccessKeyFocuses" = false;

        # Save files to ~/Downloads without asking.
        "browser.download.folderList" = 2;
        "browser.download.dir" = "${config.home.homeDirectory}/Downloads";
        "browser.download.useDownloadDir" = true;

        # Never translate German.
        "browser.translations.neverTranslateLanguages" = "de";

        # Do not suggest open tabs.
        "browser.urlbar.suggest.openpage" = false;

        # Highlight all search results on a page.
        "findbar.highlightAll" = true;

        # Use Jetbrains Mono with Nerd font patches as monospaced font.
        "font.name.monospace.x-western" = "JetBrainsMono Nerd Font Mono";

        # Use system locale settings.
        "intl.regional_prefs.use_os_locales" = true;

        # Improve the rendering performance by enabling Webrender.
        "gfx.webrender.all" = true;
        "gfx.webrender.compositor.force-enabled" = true;

        # Enable hardware video acceleration via VAAPI.
        "media.ffmpeg.vaapi.enabled" = true;

        # Disable the media entry from Firefox to use the one from the Plasma
        # browser integration plugin.
        "media.hardwaremediakeys.enabled" = isLinux;

        # Use the XDG desktop portal.
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "widget.use-xdg-desktop-portal.open-uri" = 1;
        "widget.use-xdg-desktop-portal.settings" = 1;

        # Do not print header and footer.
        "print.print_footerleft" = "";
        "print.print_headerright" = "";

        # Disable slow startup notifications.
        "browser.slowStartup.maxSamples" = 0;
        "browser.slowStartup.notificationDisabled" = true;
        "browser.slowStartup.samples" = 0;

        # Disable domain guessing.
        "browser.fixup.alternate.enabled" = false;

        # Disable Normandy and Shield.
        "app.normandy.enabled" = false;
        "app.shield.optoutstudies.enabled" = false;

        # Disable experiments.
        "messaging-system.rsexperimentloader.enabled" = false;

        # Disable new tab page and the activity stream.
        "browser.newtabpage.enabled" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" =
          false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" =
          false;

        # Disable Safe Browsing.
        "browser.safebrowsing.blockedURIs.enabled" = false;
        "browser.safebrowsing.downloads.enabled" = false;
        "browser.safebrowsing.downloads.remote.block_dangerous" = false;
        "browser.safebrowsing.downloads.remote.block_dangerous_host" = false;
        "browser.safebrowsing.downloads.remote.block_potentially_unwanted" =
          false;
        "browser.safebrowsing.downloads.remote.block_uncommon" = false;
        "browser.safebrowsing.downloads.remote.enabled" = false;
        "browser.safebrowsing.downloads.remote.url" = "";
        "browser.safebrowsing.malware.enabled" = false;
        "browser.safebrowsing.phishing.enabled" = false;
        "browser.safebrowsing.provider.google4.dataSharing.enabled" = false;
        "browser.safebrowsing.provider.google4.dataSharingURL" = "";
        "browser.safebrowsing.provider.google4.reportMalwareMistakeURL" = "";
        "browser.safebrowsing.provider.google4.reportPhishMistakeURL" = "";
        "browser.safebrowsing.provider.google4.reportURL" = "";
        "browser.safebrowsing.provider.google.reportMalwareMistakeURL" = "";
        "browser.safebrowsing.provider.google.reportPhishMistakeURL" = "";
        "browser.safebrowsing.provider.google.reportURL" = "";
        "browser.safebrowsing.reportPhishURL" = "";

        # Disable live search suggestions.
        "browser.search.suggest.enabled" = false;
        "browser.urlbar.suggest.searches" = false;

        # Disable geo localization.
        "geo.enabled" = false;

        # Disable Firefox location tracking.
        "browser.region.update.enabled" = false;
        "browser.region.network.url" = "";

        # Deactivate tracking protection and the 'Do not track' header since
        # ironically, they may be used for tracking.
        "privacy.trackingprotection.enabled" = false;
        "privacy.donottrackheader.enabled" = false;

        # Activate total cookie protection which puts each site's cookies in its
        # own container.
        "network.cookie.cookieBehavior" = 5;

        # Use US as locale in javascript.
        "javascript.use_us_english_locale" = true;

        # Disable Pocket and screenshots.
        "extensions.pocket.enabled" = false;
        "extensions.screenshots.disabled" = true;

        # Enforce punycode for internationalized domain names to eliminate
        # possible spoofing.
        "network.IDN_show_punycode" = true;

        # Display all parts of the URL in the location bar, e.g. http(s)://.
        "browser.urlbar.trimURLs" = false;

        # Display "insecure" icon and "Not Secure" text on insecure HTTP
        # connections.
        "security.insecure_connection_text.enabled" = true;
        "security.insecure_connection_text.pbmode.enabled" = true;

        # Operate in HTTPS-only mode.
        "dom.security.https_only_mode" = true;

        # Download mixed content via HTTPS.
        "security.mixed_content.upgrade_display_content" = true;
      };
      search = {
        force = true;
        default = "Google";
        engines = let
          nixIcon =
            "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        in {
          Bing.metaData.hidden = true;
          Hoogle = {
            definedAliases = [ "@h" "@hoogle" ];
            iconUpdateURL = "https://hoogle.haskell.org/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            urls = [{
              template = "https://hoogle.haskell.org/?hoogle={searchTerms}";
            }];
          };
          "Nix Packages" = {
            definedAliases = [ "@np" "@nixpkgs" ];
            icon = nixIcon;
            urls = [{
              template =
                "https://search.nixos.org/packages?query={searchTerms}";
            }];
          };
          "NixOS Options" = {
            definedAliases = [ "@no" "@nixosopts" ];
            icon = nixIcon;
            urls = [{
              template = "https://search.nixos.org/options?query={searchTerms}";
            }];
          };
          "NixOS Wiki" = {
            definedAliases = [ "@nw" "@nixoswiki" ];
            icon = nixIcon;
            urls = [{
              template = "https://nixos.wiki/index.php?search={searchTerms}";
            }];
          };
        };
      };
      extensions = with pkgs.nur.repos.rycee.firefox-addons;
        [
          auto-sort-bookmarks
          canvasblocker
          darkreader
          decentraleyes
          i-dont-care-about-cookies
          javascript-restrictor # aka jshelter
          keepassxc-browser
          languagetool
          privacy-badger
          simple-translate
          skip-redirect
          smart-referer
          tab-session-manager
          ublock-origin
          web-search-navigator
        ] ++ optional isLinux plasma-integration;
    };
  };

  programs.fzf = let cfg = config.programs.fzf;
  in {
    enable = true;

    changeDirWidgetCommand = "fzf-state get-source directories";

    changeDirWidgetOptions = gnuCommandArgs {
      bind = fzf-state-keybindings cfg.changeDirWidgetCommand;
      preview = dirPreview "{}";
    };

    defaultCommand = let
      args = gnuCommandLine {
        follow = true;
        hidden = true;
        type = "file";
      };
    in "fd ${args}";

    defaultOptions = let
      arrowHead = "❯";
      keybindings = escapeShellArg (concatStringsSep "," [
        "ctrl-f:half-page-down"
        "ctrl-b:half-page-up"
        "alt-a:toggle-all"
        "f3:toggle-preview-wrap"
        "f4:toggle-preview"
        "f5:change-preview-window(nohidden,down|nohidden,left|nohidden,up|nohidden,right)"
      ]);
    in gnuCommandArgs {
      bind = keybindings;
      border = "horizontal";
      color = "16,info:8,border:8";
      height = "60%";
      layout = "reverse";
      marker = arrowHead;
      pointer = arrowHead;
      prompt = escapeShellArg "${arrowHead} ";
      preview-window = "right,border,hidden";
    };

    fileWidgetCommand = "fzf-state get-source files";

    fileWidgetOptions = gnuCommandArgs {
      bind = fzf-state-keybindings cfg.fileWidgetCommand;
      preview = escapeShellArg "bat ${gnuCommandLine filePreviewArgs} {}";
    };
  };

  programs.fzf-tab-completion = {
    enable = !isDarwin;
    prompt = "❯ ";
    zshExtraConfig = ''
      zstyle ':completion:*' fzf-search-display true  # search completion descriptions
      zstyle ':completion:*' fzf-completion-opts --tiebreak=chunk  # do not skew the ordering

      keys=(
          ctrl-y:accept:'repeat-fzf-completion'  # accept the completion and retrigger it
          alt-enter:accept:'zle accept-line'  # accept the completion and run it
      )
      zstyle ':completion:*' fzf-completion-keybindings "''${keys[@]}"

      # Also accept and retrigger completion when pressing / when completing cd
      zstyle ':completion::*:cd:*' fzf-completion-keybindings "''${keys[@]}" /:accept:'repeat-fzf-completion'
    '';
  };

  programs.gcc = {
    enable = true; # for nvim-treesitter
    colors = {
      error = "01;31";
      warning = "01;35";
      note = "01;36";
      caret = "01;32";
      locus = "01;33";
      quote = "01;34";
    };
  };

  programs.git = {
    enable = true;
    userName = "Benedikt Rips";
    userEmail = "benedikt.rips@gmail.com";
    signing.key = null;
    signing.signByDefault = true;

    delta = {
      enable = true;
      options = let
        fg = "normal";
        hunk_color = "magenta";
      in {
        file-modified-label = "𝚫";
        hunk-header-decoration-style = "${hunk_color} ul";
        hunk-header-line-number-style = "${hunk_color}";
        hunk-header-style = "${hunk_color} line-number";
        minus-style = "${fg} auto";
        minus-emph-style = "${fg} auto";
        navigate = "true";
        plus-style = "${fg} auto";
        plus-emph-style = "${fg} auto";
        syntax-theme = "base16";
        width = 80;
        zero-style = "${fg}";
      };
    };

    extraConfig = {
      advice.detachedHead = false;
      advice.statusHints = false;
      core.whitespace = "tabwidth=4";
      commit.template = store ./git/commit_message_template;
      credential.helper = if isDarwin then "osxkeychain" else "cache";
      diff.algorithm = "histogram";
      diff.colorMoved = "default";
      diff.renames = "copy";
      fetch.prune = true;
      fetch.writeCommitGraph = true;
      init.defaultBranch = "main";
      init.templateDir = store ./git/templates;
      log.date = "human";
      merge.ff = "only";
      merge.tool = "nvim";
      pull.rebase = true;
      push.gpgSign = "if-asked";
      rebase.missingCommitsCheck = "error";
      rerere.enabled = true;
      stash.showStat = true;
      status.showStash = true;

      # use HTTPS instead of plain Git for Github
      url."https://github.com/".insteadOf = "git://github.com/";

      color = {
        diff = {
          frag = "magenta bold";
          meta = "blue";
          whitespace = "red reverse";
        };
        status = {
          nobranch = "red bold";
          unmerged = "blue";
        };
      };

      diff.tool = "difftastic";
      difftool.difftastic.cmd = ''difft "$LOCAL" "$REMOTE"'';
      difftool.prompt = false;
      pager.difftool = true;

      mergetool.nvim = {
        cmd = ''nvim -d "$LOCAL" "$MERGED" "$REMOTE"'';
        trustExitCode = false;
      };
    };

    aliases = {
      a = "add";
      b = "branch";
      c = "commit";
      ca = "commit --amend";
      cf = "commit --fixup";
      co = "checkout";
      cp = "cherry-pick";
      cu = "commit --amend --no-edit";
      d = "diff";
      ds = "diff --staged";
      dt = "difftool";
      l = "log";
      lg = "log --oneline --graph";
      lo = "log --oneline";
      ls = "ls-files";
      lv =
        "log --format='%C(auto)%h%d %s - %C(blue)%an%C(reset), %C(magenta)%ad%C(reset)'";
      mc = "diff --name-only --diff-filter=U";
      mt = "mergetool";
      pushf = "push --force-with-lease";
      r = "reset";
      rb = "rebase";
      rbf = "rebase --interactive --autosquash --autostash";
      s = "status --short";
      sl = "shortlog";
      sw = "switch";
    };

    attributes = let
      diffDrivers = {
        bib = "bibtex";
        "c++" = "cpp";
        cpp = "cpp";
        css = "css";
        html = "html";
        java = "java";
        md = "markdown";
        php = "php";
        pl = "perl";
        py = "python";
        rb = "ruby";
        rs = "rust";
        tex = "tex";
        xhtml = "html";
      };
    in [ "* text=auto" ]
    ++ mapAttrsToList (ext: driver: "*.${ext} diff=${driver}") diffDrivers;

    ignores = [ "Session*.vim" "taskell.md" ] ++ optionals isDarwin [
      ".DS_Store" # MacOS directory preferences
    ] ++ optionals isLinux [
      ".directory" # KDE directory preferences
    ];
  };

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = isLinux;
    pinentryPackage = with pkgs; if isDarwin then pinentry_mac else pinentry-qt;
    defaultCacheTtl = 3600; # at least one hour
    maxCacheTtl = 43200; # 12 hours at most
  };

  programs.goto.enable = true;

  programs.grep = {
    enable = true;
    colors = {
      ms = "01;31";
      mc = "01;31";
      sl = "";
      cx = "";
      fn = "35";
      ln = "32";
      bn = "32";
      se = "36";
    };
  };

  programs.less = {
    enable = true;
    settings = {
      LONG-PROMPT = true;
      RAW-CONTROL-CHARS = true;
      quiet = true;
      quit-if-one-screen = true;
      wheel-lines = 3;
    };
  };

  programs.man.generateCaches = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withRuby = false;
  };

  services.nextcloud-client.enable = isLinux;
  services.owncloud-client.enable = isLinux;

  programs.ripgrep = {
    enable = true;
    arguments = gnuCommandArgs {
      smart-case = true;
      colors = [
        "path:style:intense"
        "line:style:intense"
        "match:style:intense"
        "column:fg:green"
        "column:style:intense"
        "match:style:intense"
      ];
    };
  };

  programs.shellcheck = {
    enable = true;
    settings = {
      shell = "bash";
      enable = [ # enable optional checks
        "add-default-case"
        "avoid-nullary-conditions"
        "check-deprecate-which"
        "check-set-e-suppressed"
        "deprecate-which"
        "require-double-brackets"
      ];
    };
  };

  programs.ssh = {
    enable = true;
    package = pkgs.openssh;
    addKeysToAgent = "yes";
    matchBlocks = let sshHomedir = "${config.home.homeDirectory}/.ssh";
    in {
      "private/aur" = {
        host = "aur.archlinux.org";
        user = "aur";
        identityFile = "${sshHomedir}/private/aur";
      };
      "private/github" = {
        host = "github.com";
        user = "git";
        identityFile = "${sshHomedir}/private/github";
      };
      "uni-muenster" = {
        host = "*.uni-muenster.de";
        user = "git";
        identityFile = "${sshHomedir}/uni-muenster";
      };
    };
  };

  services.ssh-agent.enable = isLinux;

  programs.starship = {
    enable = true;
    settings = {
      #:schema 'https://starship.rs/config-schema.json'
      format = concatMapStrings (s: "\$${s}") [
        "all"
        "fill"
        "jobs"
        "time"
        "status"
        "os"
        "container"
        "shell"
        "line_break"
        "battery"
        "character"
      ];
      aws.symbol = " ";
      azure.symbol = " ";
      buf.symbol = " ";
      c.symbol = " ";
      conda.symbol = " ";
      container.symbol = " ";
      crystal.symbol = " ";
      dart.symbol = " ";
      directory.read_only = " 󰌾";
      directory.style = "bold blue";
      directory.truncation_length = 10;
      directory.truncate_to_repo = false;
      docker_context.symbol = " ";
      dotnet.symbol = "󰪮 ";
      elixir.symbol = " ";
      elm.symbol = " ";
      fill.symbol = " ";
      fossil_branch.symbol = " ";
      gcloud.symbol = " ";
      git_branch.symbol = " ";
      git_commit.format = "at [$hash$tag]($style) ";
      git_commit.style = "bold cyan";
      git_state.style = "bold red";
      git_status.format =
        "[($all_status )($behind$behind_count )($ahead$ahead_count )]($style)";
      git_status.style = "bold yellow";
      golang.symbol = " ";
      gradle.symbol = " ";
      guix_shell.symbol = " ";
      haskell.symbol = " ";
      haxe.symbol = " ";
      hg_branch.symbol = " ";
      hostname.ssh_symbol = " ";
      java.symbol = " ";
      jobs.number_threshold = 1;
      julia.symbol = " ";
      kotlin.symbol = " ";
      lua.symbol = " ";
      memory_usage.symbol = "󰍛 ";
      meson.symbol = "󰔷 ";
      nim.symbol = " ";
      nix_shell.symbol = " ";
      nodejs.symbol = "󰎙 ";
      ocaml.symbol = " ";
      package.symbol = "󰏗 ";
      perl.symbol = " ";
      php.symbol = "󰌟 ";
      pijul_channel.symbol = " ";
      purescript.symbol = " ";
      python.symbol = " ";
      rlang.symbol = "󰟔 ";
      ruby.symbol = "󰴭 ";
      rust.symbol = " ";
      scala.symbol = " ";
      swift.symbol = " ";
      terraform.symbol = " ";
      vlang.symbol = " ";
      zig.symbol = " ";
    };
  };

  programs.taskell = {
    enable = true;
    package = nixpkgs_23_05.taskell;
    bindings = {
      new = "n, a";
      edit = "e";
      clear = "c";
      delete = "d";
      listNew = "N, A";
      listEdit = "E";
      listDelete = "D";
    };
    config = {
      general.filename = "taskell.md";
      layout = {
        padding = 1;
        column_width = 30;
        column_padding = 3;
        description_indicator = "≡";
        statusbar = true;
      };
      markdown = {
        title = "##";
        task = "-";
        summary = "    >";
        due = "    @";
        subtask = "    *";
        localTimes = false;
      };
    };
    template = ''
      ## To Do
      ## Done
    '';
    theme.other = {
      statusBar.fg = "default";
      statusBar.bg = "brightBlack";
      subtaskCurrent.fg = "magenta";
      subtaskIncomplete.fg = "default";
      subtaskComplete.fg = "blue";
    };
  };

  programs.thefuck.enable = true;

  programs.zsh = {
    enable = true;
    profileExtra = mkIf isDarwin readNixInitScript;
    defaultKeymap = "viins";
    useInNixShell = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    history = rec {
      extended = true;
      ignoreSpace = false;
      path = "${config.xdg.stateHome}/zsh/history";
      save = size;
      share = false;
      size = 100000;
    };
    options = {
      auto_pushd = true;
      extended_glob = true;
      hist_reduce_blanks = true;
      inc_append_history_time = true;
      null_glob = true; # remove patterns without matches from argument list
      sh_word_split = true; # split fields like in Bash
    };
    shellGlobalAliases = {
      C = "| wc -l";
      G = "| rg";
      H = "| head";
      L = "| less";
      NE = "2>/dev/null";
      NO = "&>/dev/null";
      S = "| sort";
      T = "| tail";
      U = "| uniq";
      V = "| nvim";
      X = "| xargs";
    };
    completionInit = ''
      zmodload zsh/complist

      bindkey -M menuselect '^A' send-break # abort
      bindkey -M menuselect '^H' vi-backward-char # left
      bindkey -M menuselect '^J' vi-down-line-or-history # down
      bindkey -M menuselect '^K' vi-up-line-or-history # up
      bindkey -M menuselect '^L' vi-forward-char # right
      bindkey -M menuselect '^N' vi-forward-blank-word # next group
      bindkey -M menuselect '^P' vi-backward-blank-word # previous group
      bindkey -M menuselect '^T' accept-and-hold # hold
      bindkey -M menuselect '^U' undo
      bindkey -M menuselect '^Y' accept-and-infer-next-history # next

      autoload -Uz compinit
      compinit -d "${config.xdg.cacheHome}/zsh/zcompdump-$ZSH_VERSION"

      _comp_option+=(globdots)  # include hidden files in completion

      zstyle ':completion:*' menu select  # enable menu style completion

      zstyle ':completion:*' use-cache yes
      zstyle ':completion:*' cache-path '${config.xdg.cacheHome}/zsh/completion'

      zstyle ':completion:*' verbose yes
      zstyle ':completion:*:descriptions' format "$fg[yellow]%B--- %d%b"
      zstyle ':completion:*:messages' format '%d'
      zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
      zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
      zstyle ':completion:*' group-name '''

      zstyle ':completion:*' keep-prefix yes  # keep a prefix containing ~ or a param
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}  # colorized completion
      zstyle ':completion:*' squeeze-slashes yes  # remove trailing slashes
    '';
    siteFunctions = {
      cd_parent = ''
        zle push-line
        BUFFER="cd .."
        zle accept-line
        local ret=$?
        zle reset-prompt
        return $ret
      '';
      cd_undo = ''
        zle push-line
        BUFFER="popd"
        zle accept-line
        local ret=$?
        zle reset-prompt
        return $ret
      '';
      fzf-cdhist-widget = ''
        local dir="$(${pkgs.gnused}/bin/sed "s#$HOME#~#" ${config.xdg.stateHome}/cd_history | FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_CDHIST_OPTS" ${config.programs.fzf.package}/bin/fzf | ${pkgs.gnused}/bin/sed "s#~#$HOME#")"
        if [[ -z "$dir" ]]; then
            zle redisplay
            return 0
        fi
        zle push-line # Clear buffer. Auto-restored on next prompt.
        BUFFER="cd -- ''${(q)dir}"
        zle accept-line
        local ret=$?
        zle reset-prompt
        return $ret
      '';
      fzf-goto-widget = ''
        _goto_resolve_db
        local dir="$(${pkgs.gnused}/bin/sed 's/ /:/' $GOTO_DB | column -t -s : | FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_GOTO_OPTS" ${config.programs.fzf.package}/bin/fzf | ${pkgs.gnused}/bin/sed "s/^[a-zA-Z]* *//")"
        if [[ -z "$dir" ]]; then
            zle redisplay
            return 0
        fi
        zle push-line # Clear buffer. Auto-restored on next prompt.
        BUFFER="cd -- ''${(q)dir}"
        zle accept-line
        local ret=$?
        zle reset-prompt
        return $ret
      '';
      fzf-grep-widget = let
        grep = stringAsChars (c: if c == "\n" then "; " else c) ''
          local item
          eval $FZF_GREP_COMMAND "" | FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_GREP_OPTS" ${config.programs.fzf.package}/bin/fzf --bind="change:reload($FZF_GREP_COMMAND {q} || true)" --ansi --disabled --delimiter=: | ${pkgs.gnused}/bin/sed 's/:.*$//' | ${pkgs.coreutils}/bin/uniq | while read item; do
              echo -n "''${(q)item} "
          done
          local ret=$?
          echo
          return $ret
        '';
      in ''
        LBUFFER="''${LBUFFER}$(${grep})"
        local ret=$?
        zle reset-prompt
        return $ret
      '';
      git = gitWrapper;
      mkcd = mkcd;
      rationalise-dot = ''
        if [[ $LBUFFER == *[\ /].. || $LBUFFER == .. ]]; then
          LBUFFER+=/..
        else
          LBUFFER+=.
        fi
      '';
    };
    initExtraFirst = ''
      # If not running interactively, don't do anything
      [[ $- != *i* ]] && return
    '';
    initExtra = ''
      ${initExtra}

      autoload -Uz git mkcd

      autoload -Uz edit-command-line
      zle -N edit-command-line
      bindkey          '^V' edit-command-line
      bindkey -M vicmd '^V' edit-command-line

      # Help for builtin commands
      unalias run-help
      autoload -Uz run-help

      # Go upwards quickly by typing sequences of dots
      autoload -Uz rationalise-dot
      zle -N rationalise-dot
      bindkey . rationalise-dot

      # Next/previous history item which the command line is a prefix of
      autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search
      bindkey '^J' down-line-or-beginning-search
      bindkey '^K' up-line-or-beginning-search

      # autosuggestion keybindings
      bindkey '^E' forward-word
      bindkey '^G' autosuggest-execute

      # Go back with <C-o>
      autoload -Uz cd_undo
      zle -N cd_undo
      bindkey '^O' cd_undo

      # Go to parent dir with <C-p>
      autoload -Uz cd_parent
      zle -N cd_parent
      bindkey '^P' cd_parent

      # fix the home, end and delete keys
      bindkey '^[[H' beginning-of-line
      bindkey '^[[F' end-of-line
      bindkey '^[[3~' delete-char
      bindkey '^[3;5~' delete-char

      # Select files with Ctrl+Space, history with Ctrl+/, directories with Ctrl+T
      bindkey '^ ' fzf-file-widget
      bindkey '^_' fzf-history-widget
      bindkey '^T' fzf-cd-widget

      bindkey -M vicmd '^R' redo  # restore redo

      # preview when completing env vars (note: only works for exported variables)
      # eval twice, first to unescape the string, second to expand the $variable
      zstyle ':completion::*:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-completion-opts --preview='eval eval echo {1}' --preview-window=wrap

      #[ Go to `goto` bookmark ]#
      autoload -Uz fzf-goto-widget
      zle -N fzf-goto-widget
      bindkey '^B' fzf-goto-widget

      #[ Go to directory in cd history ]#
      autoload -Uz fzf-cdhist-widget
      zle -N fzf-cdhist-widget
      bindkey '^Y' fzf-cdhist-widget

      #[ Interactive grep ]#
      autoload -Uz fzf-grep-widget
      zle -N fzf-grep-widget
      bindkey '^F' fzf-grep-widget

      bindkey -M viins 'jk' vi-cmd-mode
      bindkey -M vicmd ' ' execute-named-cmd

      # Adapt the __vi_cursor to the mode
      autoload -Uz add-zsh-hook add-zsh-hook-widget

      typeset -Ag __vi_cursor=(
          insert '\e[6 q' # beam
          normal '\e[0 q' # underline
          operator_pending '\e[4 q' # block
      )

      function __restore_cursor() {
          echo -ne "''${__vi_cursor[normal]}"
      }
      add-zsh-hook precmd __restore_cursor

      function zle-line-init() {
          echo -ne "''${__vi_cursor[insert]}"
      }
      zle -N zle-line-init

      function zle-keymap-select {
          case $KEYMAP in
              viins|main) echo -ne "''${__vi_cursor[insert]}"  ;;
              viins|main) echo -ne "''${__vi_cursor[operator_pending]}" ;;
              *)          __restore_cursor ;;
          esac
      }
      zle -N zle-keymap-select

      # Increment with <C-a>
      autoload -Uz incarg
      zle -N incarg
      bindkey -M vicmd '^A' incarg

      # Text operators for quotes and blocks.
      autoload -Uz select-bracketed select-quoted
      zle -N select-quoted
      zle -N select-bracketed
      for km in viopp visual; do
          for c in {a,i}''${(s..)^:-q\'\"\`}; do
              bindkey -M $km -- $c select-quoted
          done
          for c in {a,i}''${(s..)^:-'bB()[]{}<>'}; do
              bindkey -M $km -- $c select-bracketed
          done
      done

      # vim-surround
      autoload -Uz surround
      zle -N delete-surround surround
      zle -N add-surround surround
      zle -N change-surround surround
      bindkey -a 'cs' change-surround
      bindkey -a 'ds' delete-surround
      bindkey -a 'ys' add-surround
      bindkey -M visual 'S' add-surround
    '';
  };

  home.packages = with packageSets;
    core ++ extra ++ gui ++ optionals isLinux tex ++ optionals isDarwin macos;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  # See also `xdg.configFile` and `xdg.dataFile`.
  home.file = { };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
