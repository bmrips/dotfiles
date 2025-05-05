final: _prev:

{
  bt-dualboot = final.callPackage ./bt-dualboot.nix { };
  fzf-tab-completion = final.callPackage ./fzf-tab-completion.nix { };
  rl_custom_function = final.callPackage ./rl_custom_function.nix { };
}
