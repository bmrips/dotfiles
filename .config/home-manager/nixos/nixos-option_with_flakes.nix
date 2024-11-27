final: prev:

let
  flake-compat = prev.fetchFromGitHub {
    owner = "edolstra";
    repo = "flake-compat";
    rev = "12c64ca55c1014cdc1b16ed5a804aa8576601ff2";
    sha256 = "sha256-hY8g6H2KFL8ownSiFeMOjwPC8P0ueXpCVEbxgda3pko=";
  };
  prefix =
    "(import ${flake-compat} { src = /etc/nixos; }).defaultNix.nixosConfigurations.\\$(hostname)";

in {
  nixos-option =
    prev.runCommand "nixos-option" { buildInputs = [ prev.makeWrapper ]; } ''
      makeWrapper ${prev.nixos-option}/bin/nixos-option $out/bin/nixos-option \
        --add-flags --config_expr \
        --add-flags "\"${prefix}.config\"" \
        --add-flags --options_expr \
        --add-flags "\"${prefix}.options\""
    '';
}
