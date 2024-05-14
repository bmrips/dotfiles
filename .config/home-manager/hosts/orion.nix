{ pkgs, ... }:

{
  imports = [
    ../profiles/core.nix
    ../profiles/kde-plasma.nix
    ../profiles/linux.nix
    ../profiles/uni-muenster.nix
  ];

  home.packages = with pkgs; [
    # git-latexdiff # conflicts with texlive
    texlab
    texliveFull
  ];
}
