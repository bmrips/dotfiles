{ config, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink';

in
{
  home.file.".haskeline".source = mkOutOfStoreSymlink' ./haskeline;
  xdg.configFile = {
    "ghc/ghci.conf".source = mkOutOfStoreSymlink' ./ghci.conf;
    "ideavim/ideavimrc".source = mkOutOfStoreSymlink' ./ideavimrc;
    "latexmk/latexmkrc".source = mkOutOfStoreSymlink' ./latexmkrc;
    "procps/toprc".source = mkOutOfStoreSymlink' ./toprc;
  };
}
