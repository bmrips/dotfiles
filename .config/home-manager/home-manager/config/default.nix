{ config, lib, pkgs, ... }:

with lib;

let
  inherit (pkgs.lib) ansiEscapeCodes gnuCommandLine;
  inherit (pkgs.lib.ansiEscapeCodes) base16 reset;

  nixpkgs_23_05 = import (fetchTarball {
    name = "nixpks-23.05-darwin-20231231";
    url =
      "https://github.com/NixOS/nixpkgs/archive/2c9c58e98243930f8cb70387934daa4bc8b00373.tar.gz";
    sha256 = "0mk8p5sr5b507q4045ssrjmc4rghkfxa1fzr25idj2z9gbyf1f3s";
  }) { };

  packageSets = {
    core = with pkgs; [
      coreutils-full
      diffutils
      dos2unix
      fd
      file
      findutils
      gnused
      man-db
      ncdu
      (nerdfonts.override {
        fonts = [
          # "Hasklig"
          "JetBrainsMono"
        ];
      })
      tokei
      tree
    ];
    extra = with pkgs; [
      cbfmt
      difftastic
      lua54Packages.digestif
      eza
      gfold
      git-cliff
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
      treefmt2
      vale-ls
    ];
  };

in {
  imports = [
    ./ci/pre-commit.nix
    ./development/bash.nix
    ./development/container.nix
    ./development/kubernetes.nix
    ./development/lua.nix
    ./development/markdown.nix
    ./development/nix.nix
    ./development/yaml.nix
    ./profiles/adesso.nix
    ./profiles/gui.nix
    ./profiles/kde-plasma.nix
    ./profiles/linux.nix
    ./profiles/macos.nix
    ./profiles/standalone.nix
    ./profiles/uni-muenster.nix
    ./programs/bash.nix
    ./programs/bat.nix
    ./programs/dircolors.nix
    ./programs/direnv.nix
    ./programs/firefox.nix
    ./programs/fzf-tab-completion.nix
    ./programs/fzf.nix
    ./programs/git/default.nix
    ./programs/goto.nix
    ./programs/less.nix
    ./programs/mkcd.nix
    ./programs/neovim.nix
    ./programs/ripgrep.nix
    ./programs/shellcheck.nix
    ./programs/ssh.nix
    ./programs/starship.nix
    ./programs/taskell.nix
    ./programs/yamllint.nix
    ./programs/zoxide.nix
    ./programs/zsh.nix
  ];

  ci.pre-commit.enable = true;

  development.bash.enable = true;
  development.lua.enable = true;
  development.markdown.enable = true;
  development.nix.enable = true;
  development.yaml.enable = true;

  fonts.fontconfig.enable = true;

  home.language = let
    english = "en_GB.UTF-8";
    german = "de_DE.UTF-8";
  in {
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

  home.packages = with packageSets; core ++ extra;

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

    c = "cd";
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
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.username = "bmr";

  nix = {
    nixPath = [ "${config.xdg.stateHome}/nix/defexpr/channels" ];
    settings = {
      experimental-features = "flakes nix-command";
      use-xdg-base-directories = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  programs.bash.enable = true;
  programs.bat.enable = true;
  programs.command-not-found.enable = true;
  programs.dircolors.enable = true;
  programs.direnv.enable = true;
  programs.fzf.enable = true;
  programs.fzf-tab-completion.enable = true;

  programs.gcc.colors = with base16; {
    error = bold red;
    warning = bold magenta;
    note = bold cyan;
    caret = bold green;
    locus = bold yellow;
    quote = bold blue;
  };

  programs.git.enable = true;
  programs.gpg.enable = true;
  programs.goto.enable = true;

  programs.grep = {
    enable = true;
    colors = with base16; {
      ms = bold red;
      mc = bold red;
      sl = reset;
      cx = reset;
      fn = normal magenta;
      ln = normal green;
      bn = normal green;
      se = normal cyan;
    };
  };

  programs.home-manager.enable = true;
  programs.less.enable = true;
  programs.man.generateCaches = true;
  programs.neovim.enable = true;
  programs.ripgrep.enable = true;
  programs.ssh.enable = true;
  programs.starship.enable = true;
  programs.taskell.enable = true;
  programs.thefuck.enable = true;
  programs.yazi.enable = true;
  programs.zoxide.enable = true;
  programs.zsh.enable = true;

  xdg.enable = true;
}
