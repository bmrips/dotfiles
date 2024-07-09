{ pkgs, ... }:

{
  imports = [
    ../profiles/core.nix
    ../profiles/kde-plasma.nix
    ../profiles/linux.nix
    ../profiles/uni-muenster.nix
  ];

  home.packages = with pkgs; [ texlab texliveFull ];
}
