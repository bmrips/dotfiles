let
  rev = "442d407992384ed9c0e6d352de75b69079904e4e";
  sha256 = "0rbaxymznpr2gfl5a9jyii5nlpjc9k2lrwlw2h5ccinds58c202k";
in import (fetchTarball {
  name = "nixpkgs";
  url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
  inherit sha256;
})
