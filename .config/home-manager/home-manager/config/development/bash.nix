{ config, lib, pkgs, ... }:

with lib;

let cfg = config.development.bash;

in {
  options.development.bash.enable = mkEnableOption "Bash development tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ bash-language-server checkbashisms shfmt ];

    programs.bash.enable = true;
    programs.shellcheck.enable = true;
  };
}
