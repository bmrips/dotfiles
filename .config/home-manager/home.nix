{ config, lib, pkgs, ... }:

let
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
      bat
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
      git
      gitlint
      gnugrep
      gnupg
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
      openssh
      podman
      pre-commit
      python3Packages.mdformat
      python3Packages.mdformat-footnote
      python3Packages.mdformat-gfm
      python3Packages.mdformat-tables
      ripgrep
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

in {
  programs.home-manager.enable = true;

  home.username = "bmr";
  home.homeDirectory = "/home/${config.home.username}";

  fonts.fontconfig.enable = true;

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
