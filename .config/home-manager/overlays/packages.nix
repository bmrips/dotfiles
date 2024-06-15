final: prev:

{
  fzf-tab-completion = final.callPackage ./packages/fzf-tab-completion.nix { };
  goto = final.callPackage ./packages/goto.nix { };
}
