{ config, lib, pkgs, ... }:

with lib;

let
  inherit (pkgs.lib) gnuCommandArgs gnuCommandLine;
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

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
      translate-shell
      treefmt
      yaml-language-server
    ];
  };

  locales = {
    english = "en_GB.UTF-8";
    german = "de_DE.UTF-8";
  };

  mkcd = ''mkdir --parents "$1" && cd "$1"'';

in {
  nixpkgs.overlays = import ./overlays/default.nix;

  imports = import ./modules.nix;

  programs.home-manager.enable = true;

  home.username = "bmr";

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

  home.sessionVariables.TEXEDIT =
    "${config.home.sessionVariables.EDITOR} +%d %s";

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
    gl = "glab";
    hm = "home-manager";
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
  };

  fonts.fontconfig.enable = true;

  programs.bash = {
    enable = true;
    historyControl = [ "ignoredups" ];
    historyFile = "${config.xdg.stateHome}/bash/history";
    initExtra = ''
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

  programs.command-not-found.enable = true;

  programs.dircolors.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config.global.hide_env_diff = true;
  };

  programs.fzf.enable = true;

  programs.fzf-tab-completion.enable = true;

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

  programs.git.enable = true;

  programs.gpg.enable = true;

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
    matchBlocks = {
      "private/aur" = {
        host = "aur.archlinux.org";
        user = "aur";
        identityFile = "~/.ssh/private/aur";
      };
      "private/github" = {
        host = "github.com";
        user = "git";
        identityFile = "~/.ssh/private/github";
      };
    };
  };

  programs.starship.enable = true;

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

  programs.yamllint = {
    enable = true;
    settings = {
      extends = "default";
      rules = {
        document-end = "disable";
        document-start = "disable";
        empty-values = "enable";
        float-values.require-numeral-before-decimal = true;
      };
    };
  };

  programs.zsh = {
    enable = true;
    siteFunctions.mkcd = mkcd;
    initExtra = ''
      autoload -Uz mkcd
    '';
  };

  home.packages = with packageSets; core ++ extra;

  profiles.adesso.enable = isDarwin;
  profiles.gui.enable = true;
  profiles.kde-plasma.enable = isLinux;
  profiles.linux.enable = isLinux;
  profiles.macos.enable = isDarwin;
  profiles.uni-muenster.enable = isLinux;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
