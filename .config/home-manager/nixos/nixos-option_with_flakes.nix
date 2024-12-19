flake-compat: final: prev:

let
  prefix =
    "(import ${flake-compat} { src = /etc/nixos; }).defaultNix.nixosConfigurations.\\$(hostname)";

in {
  nixos-option = prev.runCommandLocal "nixos-option" {
    buildInputs = [ prev.makeWrapper ];
  } ''
    makeWrapper ${prev.nixos-option}/bin/nixos-option $out/bin/nixos-option \
      --add-flags --config_expr \
      --add-flags "\"${prefix}.config\"" \
      --add-flags --options_expr \
      --add-flags "\"${prefix}.options\""
  '';
}
