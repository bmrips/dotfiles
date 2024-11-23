final: prev:

{
  fzf-tab-completion = final.callPackage ./fzf-tab-completion.nix { };
  goto = final.callPackage ./goto.nix { };
}
