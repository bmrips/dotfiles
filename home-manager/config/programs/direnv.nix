{ config, lib, ... }:

{
  programs.direnv = {
    config.global.hide_env_diff = true;
    nix-direnv.enable = true;
  };

  programs.git.ignores = lib.mkIf config.programs.direnv.enable [ "/.direnv/" ];
}
