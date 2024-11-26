{ coreutils-full, fetchFromGitHub, fzf, gawk, gnugrep, lib, stdenv, }:

let owner = "lincheney";

in stdenv.mkDerivation rec {
  pname = "fzf-tab-completion";
  version = "11122590127ab62c51dd4bbfd0d432cee30f9984";

  src = fetchFromGitHub {
    inherit owner;
    repo = pname;
    rev = version;
    hash = "sha256-ds+GgCTXXavaELCy0MxAGHTPp2MFoFohm/gPkQCRuXU=";
  };

  strictDeps = true;

  buildInputs = [ coreutils-full fzf gawk gnugrep ];

  postInstall = ''
    mkdir --parents $out/share/${pname}/
    cp --recursive bash/ zsh/ $out/share/${pname}/
  '';

  meta = with lib; {
    description = "Tab completion using fzf";
    homepage = "https://github.com/${owner}/${pname}";
    license = licenses.gpl3Plus;
  };
}
