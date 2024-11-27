{
  programs.direnv = {
    config.global.hide_env_diff = true;
    nix-direnv.enable = true;
  };
}
