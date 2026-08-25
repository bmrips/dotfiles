{
  config,
  lib,
  pkgs,
  defaultsPkgs,
  ...
}:

{
  options.development.bash.enable = lib.mkEnableOption "Bash development tools";

  config = lib.mkIf config.development.bash.enable {
    home.packages = [
      pkgs.bash-language-server
      pkgs.checkbashisms
      defaultsPkgs.shellcheck
      defaultsPkgs.shfmt
    ];

    programs.bash.enable = true;
  };
}
