{ config, ... }:

{
  services.davmail = {
    imitateOutlook = true;
    settings.davmail = {
      mode = "O365Interactive";
      persistToken = true;
      oauth.tokenFilePath = "${config.xdg.stateHome}/davmail/tokens";
    };
  };
}
