{
  programs.direnv = {
    config.global.hide_env_diff = true;
    enableGitIntegration = true;
    nix-direnv.enable = true;
  };
}
