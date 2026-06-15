{
  config,
  lib,
  osConfig,
  ...
}:

let
  cfg = config.sops;
in
{
  sops = {
    defaultSopsFile = ./secrets.yaml;
    age =
      if config.submoduleSupport.enable then
        { inherit (osConfig.sops.age) keyFile; }
      else
        {
          keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
          generateKey = true;
        };
  };

  lib.sops = {
    pathRead = secret: lib.mkIf (cfg.secrets ? ${secret}) "$(<'${cfg.secrets.${secret}.path}')";
    pathUnit =
      secret:
      lib.optional (cfg.secrets ? ${secret}) {
        inherit (cfg.secrets.${secret}) path;
        dependsOn = [ "sops-nix.service" ];
      };
  };
}
