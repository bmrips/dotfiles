{ coreutils-full, fetchFromGitHub, fzf, gawk, gnugrep, lib, stdenv, }:

let owner = "lincheney";

in stdenv.mkDerivation rec {
  pname = "fzf-tab-completion";
  version = "9bcc7098f79510765b9f539118dd92a2366ec992";

  src = fetchFromGitHub {
    inherit owner;
    repo = pname;
    rev = version;
    hash = "sha256-lEIIQAUvmsP87SJLvsuk8Ek4/9baV4LFjcvrtZuc69I=";
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
