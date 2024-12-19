{
  coreutils-full,
  gawk,
  lib,
  stdenv,
  fetchFromGitHub,
}:

let
  owner = "iridakos";

in
stdenv.mkDerivation rec {
  pname = "goto";
  version = "2.1.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = pname;
    # version 2.1.0 is not tagged
    rev = "b7fda54e0817b9cb47e22a78bd00b4571011cf58";
    hash = "sha256-dUxim8LLb+J9cI7HySkmC2DIWbWAKSsH/cTVXmt8zRo=";
  };

  strictDeps = true;

  buildInputs = [
    coreutils-full
    gawk
  ];

  postInstall = ''
    install -Dm644 goto.sh -t $out/share/
  '';

  meta = {
    description = "Alias and navigate to directories with tab completion in Linux";
    homepage = "https://github.com/${owner}/${pname}";
    downloadPage = "https://github.com/${owner}/${pname}/tags";
    changelog = "https://github.com/${owner}/${pname}/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
  };
}
