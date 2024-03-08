let
  nixpkgs = import <nixpkgs> { };
  nixpkgs_23_05 = import (fetchTarball {
    name = "nixpks-23.05-darwin-20231231";
    url =
      "https://github.com/NixOS/nixpkgs/archive/2c9c58e98243930f8cb70387934daa4bc8b00373.tar.gz";
    sha256 = "0mk8p5sr5b507q4045ssrjmc4rghkfxa1fzr25idj2z9gbyf1f3s";
  }) { };
in rec {
  adesso = core ++ development ++ extra ++ macos ++ operation;
  core = with nixpkgs; [
    bash
    bash-completion
    bat
    cdhist
    checkbashisms
    coreutils-full
    delta
    diff-so-fancy
    diffutils
    direnv
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
    nix
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
  development = with nixpkgs; [
    gradle
    gradle-completion
    nodejs
    dbeaver
    postgresql
  ];
  extra = with nixpkgs; [
    cbfmt
    difftastic
    eza
    gfold
    git-cliff
    git-latexdiff
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
  kde = with nixpkgs; [ pinentry-qt ];
  macos = with nixpkgs; [
    iterm2
    monitorcontrol
    qemu # for podman
  ];
  operation = with nixpkgs; [
    argocd
    azure-cli
    # dive
    kubectl
    kubelogin
    kubernetes-helm
    yq-go
  ];
  private = core ++ extra ++ kde;
}
