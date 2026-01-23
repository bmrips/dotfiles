{
  config,
  osConfig,
  pkgs,
  ...
}:

let
  print-colors = pkgs.writeShellApplication {
    name = "print-colors";
    text = ''
      for C in {40..47}; do
        printf "\e[''${C}m%3s" "$C"
      done
      echo
      for C in {100..107}; do
        printf "\e[''${C}m%3s" "$C"
      done
    '';
  };

in
{
  development.bash.enable = true;
  development.json.enable = true;
  development.lua.enable = true;
  development.markdown.enable = true;
  development.nix.enable = true;
  development.yaml.enable = true;

  fonts.fontconfig.enable = true;

  home.defaultCommandFlags = {
    chgrp.preserve-root = true;
    chmod.preserve-root = true;
    chown.preserve-root = true;
    cp.interactive = true;
    df.human-readable = true;
    diff.color = "auto";
    dmesg.color = "auto";
    du.human-readable = true;
    free.human = true;
    ls = {
      color = true;
      group-directories-first = true;
      human-readable = true;
      literal = true;
      time-style = "long-iso";
    };
    mv.interactive = true;
    rm.preserve-root = true;
    tree.C = true; # always colourise output
    tree.dirsfirst = true;
    wget.continue = true;
  };

  home.language =
    let
      english = "en_GB.UTF-8";
      german = "de_DE.UTF-8";
    in
    {
      base = english;
      ctype = german;
      monetary = german;
      numeric = german;
    };

  home.packages = with pkgs; [
    coreutils-full
    diffutils
    dos2unix
    file
    findutils
    gnused
    jq
    man-db
    ncdu
    nerd-fonts.jetbrains-mono
    nvd
    print-colors
    rmlint
    sd
    tokei
    tree
  ];

  home.preferXdgDirectories = true;

  home.sessionVariables.TEXEDIT = "${config.home.sessionVariables.EDITOR} +%d %s";

  home.shellAliases = {
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

  nix.settings = {
    experimental-features = "flakes nix-command";
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    max-jobs = "auto";
    use-xdg-base-directories = true;
    warn-dirty = false;
  };

  programs.bash.enable = true;
  programs.bat.enable = true;
  programs.command-not-found.enable = true;
  programs.dircolors.enable = true;
  programs.direnv.enable = true;
  programs.fd.enable = true;
  programs.fzf.enable = true;
  programs.fzf-tab-completion.enable = true;
  programs.lazygit.enable = true;
  programs.gh.enable = true;
  programs.git.enable = true;
  programs.git-credential-keepassxc.enable = true;
  programs.gpg.enable = true;
  programs.goto.enable = true;
  programs.grep.enable = true;
  programs.less.enable = true;
  programs.man.generateCaches = true;
  programs.neovim.enable = true;
  programs.nix-your-shell.enable = true;
  programs.readline.enable = true;
  programs.ripgrep.enable = true;
  programs.ripgrep-all.enable = true;
  programs.ssh.enable = true;
  programs.starship.enable = true;
  programs.taskell.enable = true;
  programs.translate-shell.enable = true;
  programs.yazi.enable = true;
  programs.zoxide.enable = true;
  programs.zsh.enable = true;

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile =
      if config.submoduleSupport.enable then
        osConfig.sops.age.keyFile
      else
        "${config.xdg.configHome}/sops/age/keys.txt";
  };

  xdg.enable = true;
}
