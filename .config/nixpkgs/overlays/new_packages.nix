final: prev:

{
  cdhist = final.callPackage ../pkgs/cdhist.nix { };
  fzf-tab-completion = final.callPackage ../pkgs/fzf-tab-completion.nix { };
  goto = final.callPackage ../pkgs/goto.nix { };
}
