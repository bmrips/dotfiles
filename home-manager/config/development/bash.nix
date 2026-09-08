{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.development.bash.enable = lib.mkEnableOption "Bash development tools";

  config = lib.mkIf config.development.bash.enable {
    home.packages = [
      pkgs.bash-language-server
      pkgs.defaults.shellcheck
      pkgs.defaults.shfmt
    ];

    programs.bash.enable = true;
  };
}
