{ config, lib, pkgs, ... }:

with lib;

{
  options.development.bash.enable = mkEnableOption "Bash development tools";

  config = mkIf config.development.bash.enable {
    home.packages = with pkgs; [ bash-language-server checkbashisms shfmt ];

    programs.bash.enable = true;
    programs.shellcheck.enable = true;
  };
}
