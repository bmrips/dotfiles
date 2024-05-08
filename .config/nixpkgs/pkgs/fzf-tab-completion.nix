{ coreutils-full, fetchFromGitHub, fzf, gawk, gnugrep, lib, stdenv, }:

let owner = "f1rstlady";

in stdenv.mkDerivation rec {
  pname = "fzf-tab-completion";
  version = "4d667e0df455478071ce9d35fc5962e5d211afec";

  src = fetchFromGitHub {
    inherit owner;
    repo = pname;
    rev = version;
    hash = "sha256-sVCRaTudPvNF8SdMabZU7EWZxEpswlbxBUy+cDGE3oA=";
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
