final: _prev:

{
  bt-dualboot = final.callPackage ./bt-dualboot.nix { };
  fzf-tab-completion = final.callPackage ./fzf-tab-completion.nix { };
  goto = final.callPackage ./goto.nix { };
}
