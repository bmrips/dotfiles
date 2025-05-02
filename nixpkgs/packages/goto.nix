{
  coreutils,
  fetchFromGitHub,
  gawk,
  lib,
  nix-update-script,
  stdenvNoCC,
}:

let
  owner = "iridakos";
  rev = "b7fda54e0817b9cb47e22a78bd00b4571011cf58";

in
stdenvNoCC.mkDerivation {
  pname = "goto";
  version = "2.1.0";

  src = fetchFromGitHub {
    inherit owner rev;
    repo = "goto";
    hash = "sha256-dUxim8LLb+J9cI7HySkmC2DIWbWAKSsH/cTVXmt8zRo=";
  };

  strictDeps = true;

  buildInputs = [
    coreutils
    gawk
  ];

  postInstall = ''
    install -Dm644 goto.sh -t $out/share/
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Alias and navigate to directories with tab completion";
    homepage = "https://github.com/${owner}/goto";
    changelog = "https://github.com/${owner}/goto/blob/${rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bmrips ];
  };
}
