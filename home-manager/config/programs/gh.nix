{ config, lib, ... }:

let
  inherit (lib) mkIf mkMerge;

in
mkMerge [

  {
    programs.gh = {
      settings.git_protocol = "ssh";
      hosts."github.com".user = "bmrips";
    };
  }

  (mkIf config.programs.gh.enable {
    sops.secrets.github_api_token = { };
    home.sessionVariables.GH_TOKEN = "$(cat ${config.sops.secrets.github_api_token.path})";
  })

]
