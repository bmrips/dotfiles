pkgs:

{
  bt-dualboot = pkgs.callPackage ./bt-dualboot.nix { };
  fzf-tab-completion = pkgs.callPackage ./fzf-tab-completion.nix { };
  rl_custom_function = pkgs.callPackage ./rl_custom_function.nix { };
}
