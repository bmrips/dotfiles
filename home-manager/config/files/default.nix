{ config, ... }:

let
  link =
    file:
    config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/home-manager/home-manager/config/files/${file}";

in
{
  home.file.".haskeline".source = link "haskeline";
  xdg.configFile = {
    "fontconfig/fonts.conf".source = link "fonts.conf";
    "ghc/ghci.conf".source = link "ghci.conf";
    "ideavim/ideavimrc".source = link "ideavimrc";
    "latexmk/latexmkrc".source = link "latexmkrc";
    "procps/toprc".source = link "toprc";
  };
}
