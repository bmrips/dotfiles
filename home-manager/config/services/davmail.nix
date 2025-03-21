{ config, ... }:

{
  services.davmail.settings.davmail = {
    persistToken = true;
    oauth.tokenFilePath = "${config.xdg.stateHome}/davmail/tokens";
  };
}
