{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.development.nix.enable = lib.mkEnableOption "Nix development tools";

  config = lib.mkIf config.development.nix.enable {
    home.packages = with pkgs; [
      nil
      nixfmt
    ];
  };
}
