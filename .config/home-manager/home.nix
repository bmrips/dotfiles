{ config, lib, pkgs, ... }:

with lib;

let
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
      cdhist
      checkbashisms
      coreutils-full
      diffutils
      dockerfile-language-server-nodejs
      dos2unix
      fd
      file
      findutils
      fzf
      fzf-tab-completion
      gcc # for nvim-treesitter
      gitlint
      gnugrep
      gnumake # for markdown-preview.nvim
      gnused
      goto
      less
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
      nixpkgs_23_05.taskell
      nodejs # for markdown-preview.nvim
      nodePackages.bash-language-server
      podman
      pre-commit
      python3Packages.mdformat
      python3Packages.mdformat-footnote
      python3Packages.mdformat-gfm
      python3Packages.mdformat-tables
      selene
      shellcheck
      shfmt
      stylua
      tokei
      tree
      yamlfmt
      zsh-nix-shell
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

in {
  programs.home-manager.enable = true;

  home.username = "bmr";
  home.homeDirectory = "/home/${config.home.username}";

  nix.package = pkgs.nix;
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = "flakes nix-command";
    use-xdg-base-directories = true;
  };

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };

  xdg.enable = true;
  xdg.userDirs.enable = true;

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
      preview = dirPreview
        (subshell "echo {} | sed 's#^~#${config.home.homeDirectory}#'");
    };
    FZF_GREP_COMMAND = "fzf-state get-source grep";
    FZF_GREP_OPTS = let
      batArgs = gnuCommandLine (filePreviewArgs // {
        line-range = subshell "fzf-state context {2}: --highlight-line={2} {1}";
      });
    in gnuCommandLine {
      bind = fzf-state-keybindings "${FZF_GREP_COMMAND} {q}";
      multi = true;
      preview = escapeShellArg "bat ${batArgs} {1}";
    };
    GCC_COLORS = concatStringsSep ":"
      (attrsets.mapAttrsToList (n: v: "${n}=${v}") {
        error = "01;31";
        warning = "01;35";
        note = "01;36";
        caret = "01;32";
        locus = "01;33";
        quote = "01;34";
      });
    GREP_COLORS = "ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36";
    LESS = gnuCommandLine {
      LONG-PROMPT = true;
      RAW-CONTROL-CHARS = true;
      quiet = true;
      quit-if-one-screen = true;
      wheel-lines = 3;
    };
    TEXEDIT = "${config.home.sessionVariables.EDITOR} +%d %s";
    YAMLLINT_CONFIG_FILE = "${config.xdg.configHome}/yamllint.yaml";
  };

  home.sessionVariablesExtra = let
    lessTermcaps = {
      md = "$'\\e[93m'"; # Bold as bright yellow
      me = "$'\\e[0m'";
      se = "$'\\e[0m'";
      so = "$'\\e[30;47m'"; # Dark grey statusline
      ue = "$'\\e[0m'";
      us = "$'\\e[4m'"; # Underline as usual
    };
  in concatLines
  (mapAttrsToList (n: v: "export LESS_TERMCAP_${n}=${v}") lessTermcaps);

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
    open = "xdg-open";
    p = "podman";
    t = "tree --gitignore";
    trash = "mv -t ${config.xdg.dataHome}/Trash/files";
    v = "nvim";
    vi = "nvim";
    vim = "nvim";
    xc = "wl-copy";
    xp = "wl-paste";
  };

  fonts.fontconfig.enable = true;

  programs.bash = {
    enable = true;
    profileExtra = ''
      source ~/.config/bash/profile.sh
    '';
    initExtra = ''
      source ~/.config/bash/rc.sh
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

  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];
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
        "browser.tabs.inTitlebar" = 0;

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
        "media.hardwaremediakeys.enabled" = false;

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
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        auto-sort-bookmarks
        canvasblocker
        darkreader
        decentraleyes
        i-dont-care-about-cookies
        javascript-restrictor # aka jshelter
        keepassxc-browser
        languagetool
        plasma-integration
        privacy-badger
        simple-translate
        skip-redirect
        smart-referer
        tab-session-manager
        ublock-origin
        web-search-navigator
      ];
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
      credential.helper = "cache";
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

    ignores = [
      ".directory" # KDE directory preferences
      ".envrc"
      "Session*.vim"
      "taskell.md"
    ];
  };

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.configHome}/gnupg";
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
    defaultCacheTtl = 3600; # at least one hour
    maxCacheTtl = 43200; # 12 hours at most
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withRuby = false;
  };

  services.nextcloud-client.enable = true;
  services.owncloud-client.enable = true;

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

  programs.ssh = {
    enable = true;
    package = pkgs.openssh;
    addKeysToAgent = "yes";
    matchBlocks = {
      aur = {
        host = "aur.archlinux.org";
        user = "aur";
        identityFile = "~/.config/ssh/private/aur";
      };
      github = {
        host = "github.com";
        user = "git";
        identityFile = "~/.config/ssh/private/github";
      };
      uni-muenster = {
        host = "*.uni-muenster.de";
        user = "git";
        identityFile = "~/.config/ssh/uni-muenster";
      };
    };
  };

  services.ssh-agent.enable = true;

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

  programs.thefuck.enable = true;

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    profileExtra = ''
      # Remove patterns without matches from the argument list
      setopt null_glob

      source ~/.config/sh/profile.sh
    '';
    initExtra = ''
      source ~/.config/zsh/rc.zsh

      bindkey '^E' forward-word
      bindkey '^G' autosuggest-execute
    '';
  };

  home.packages = with packageSets; core ++ extra ++ tex;

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
