{ config, lib, pkgs, ... }:

with lib;

let
  gnuCommandArgs = cli.toGNUCommandLine { };

  nixpkgs_23_05 = import (fetchTarball {
    name = "nixpks-23.05-darwin-20231231";
    url =
      "https://github.com/NixOS/nixpkgs/archive/2c9c58e98243930f8cb70387934daa4bc8b00373.tar.gz";
    sha256 = "0mk8p5sr5b507q4045ssrjmc4rghkfxa1fzr25idj2z9gbyf1f3s";
  }) { };

  packageSets = {
    core = with pkgs; [
      bash
      bash-completion
      cdhist
      checkbashisms
      coreutils-full
      delta
      diff-so-fancy
      diffutils
      dockerfile-language-server-nodejs
      dos2unix
      fd
      file
      findutils
      fzf
      fzf-tab-completion
      gitlint
      gnugrep
      gnused
      goto
      ltex-ls
      lua-language-server
      man-db
      markdownlint-cli
      marksman
      ncdu
      neovim
      (nerdfonts.override {
        fonts = [
          # "Hasklig"
          "JetBrainsMono"
        ];
      })
      nil
      nix-bash-completions
      nix-zsh-completions
      nixfmt
      nixpkgs_23_05.taskell
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
      starship
      stylua
      tokei
      tree
      yamlfmt
      zsh
      zsh-autosuggestions
      zsh-completions
      zsh-nix-shell
      zsh-syntax-highlighting
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

  fonts.fontconfig.enable = true;

  programs.bat = {
    enable = true;
    config = {
      italic-text = "always";
      plain = true;
      theme = "base16";
    };
  };

  programs.git = {
    enable = true;
    userName = "Benedikt Rips";
    userEmail = "benedikt.rips@gmail.com";
    signing.key = null;
    signing.signByDefault = true;

    extraConfig = {
      advice.detachedHead = false;
      advice.statusHints = false;
      core.pager = "diff-so-fancy | less";
      core.whitespace = "tabwidth=4";
      commit.template = "${./git/commit_message_template}";
      credential.helper = "cache";
      diff.algorithm = "histogram";
      diff.renames = "copy";
      diff.tool = "nvim";
      fetch.prune = true;
      fetch.writeCommitGraph = true;
      init.defaultBranch = "main";
      init.templateDir = "${./git/templates}";
      interactive.diffFilter = "delta --color-only --diff-so-fancy";
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
        diff-highlight = {
          oldNormal = "red";
          oldHighlight = "red reverse";
          newNormal = "green";
          newHighlight = "green reverse";
        };
        status = {
          nobranch = "red bold";
          unmerged = "blue";
        };
      };

      difftool.nvim.cmd = ''nvim -d "$LOCAL" "$REMOTE"'';
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
    };
  };

  services.ssh-agent.enable = true;

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
