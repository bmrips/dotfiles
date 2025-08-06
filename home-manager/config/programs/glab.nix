{ config, lib, ... }:

lib.mkMerge [

  {
    programs.glab.settings = {
      git_protocol = "ssh";
      hosts."gitlab.com".user = "bmrips";
    };
  }

  (lib.mkIf config.programs.glab.enable {
    sops.secrets.gitlab_api_token = { };
    home.sessionVariables.GITLAB_TOKEN = "$(cat ${config.sops.secrets.gitlab_api_token.path})";
  })

]
