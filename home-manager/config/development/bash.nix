{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.development.bash.enable = lib.mkEnableOption "Bash development tools";

  config = lib.mkIf config.development.bash.enable {
    home.packages = with pkgs; [
      bash-language-server
      checkbashisms
      shfmt
    ];

    programs.bash.enable = true;
    programs.shellcheck.enable = true;
  };
}
