{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:

let
  owner = "lincheney";

in
rustPlatform.buildRustPackage {
  pname = "rl_custom_function";
  version = "0-unstable-2023-03-02";

  src = fetchFromGitHub {
    inherit owner;
    repo = "rl_custom_function";
    rev = "398f757aa3a098a7e2a1e0bf8a8746c16bdf2f2d";
    hash = "sha256-A8k3ciFyYqHwVo2AjfGfxpqvL+ej39Yqfw2Fizby5BM=";
  };

  cargoHash = "sha256-TFOlsWX9PJkOnsqU7JcLhzXX5tNgJUp5z8GKOT/kulU=";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = " Inject custom functions into readline";
    homepage = "https://github.com/${owner}/rl_custom_function";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.bmrips ];
    platforms = lib.platforms.all;
  };
}
