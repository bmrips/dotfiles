{
  config,
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
  imports = [
    ./development/bash.nix
    ./development/c.nix
    ./development/container.nix
    ./development/java.nix
    ./development/kubernetes.nix
    ./development/lua.nix
    ./development/markdown.nix
    ./development/nix.nix
    ./development/yaml.nix
    ./files
    ./profiles/gui.nix
    ./profiles/linux.nix
    ./profiles/macos.nix
    ./profiles/radboud.nix
    ./profiles/standalone.nix
    ./profiles/uni-muenster.nix
    ./programs/bash.nix
    ./programs/bat.nix
    ./programs/command-not-found.nix
    ./programs/dircolors.nix
    ./programs/direnv.nix
    ./programs/dolphin.nix
    ./programs/fd.nix
    ./programs/firefox
    ./programs/fzf
    ./programs/fzf-tab-completion.nix
    ./programs/gcc.nix
    ./programs/git
    ./programs/gh.nix
    ./programs/glab.nix
    ./programs/goto.nix
    ./programs/grep.nix
    ./programs/keepassxc.nix
    ./programs/kmail.nix
    ./programs/konsole.nix
    ./programs/lazygit.nix
    ./programs/less.nix
    ./programs/merkuro.nix
    ./programs/mkcd.nix
    ./programs/neovim
    ./programs/okular.nix
    ./programs/plasma
    ./programs/readline.nix
    ./programs/ripgrep.nix
    ./programs/shellcheck.nix
    ./programs/signal-desktop.nix
    ./programs/sioyek.nix
    ./programs/slack.nix
    ./programs/starship.nix
    ./programs/taskell.nix
    ./programs/yamllint.nix
    ./programs/yazi.nix
    ./programs/zotero.nix
    ./programs/zoxide.nix
    ./programs/zsh.nix
    ./remove-leaked-path-entries.nix
  ];

  development.bash.enable = true;
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
    tree.C = true; # always colorise output
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
      address = german;
      ctype = german;
      measurement = german;
      monetary = german;
      numeric = german;
      paper = german;
      telephone = german;
      time = german;
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
    ripgrep-all
    rmlint
    sd
    tokei
    tree
  ];

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
    max-jobs = "auto";
    use-xdg-base-directories = true;
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
  programs.gpg.enable = true;
  programs.goto.enable = true;
  programs.grep.enable = true;
  programs.home-manager.enable = true;
  programs.less.enable = true;
  programs.man.generateCaches = true;
  programs.neovim.enable = true;
  programs.nix-your-shell.enable = true;
  programs.readline.enable = true;
  programs.ripgrep.enable = true;
  programs.sioyek.enable = true;
  programs.ssh.enable = true;
  programs.starship.enable = true;
  programs.taskell.enable = true;
  programs.thefuck.enable = true;
  programs.translate-shell.enable = true;
  programs.yazi.enable = true;
  programs.zoxide.enable = true;
  programs.zsh.enable = true;

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
  };

  xdg.enable = true;
}
