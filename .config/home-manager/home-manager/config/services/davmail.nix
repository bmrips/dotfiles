{ config, ... }:

{
  services.davmail.config.davmail = {
    mode = "O365Interactive";
    persistToken = true;
    oauth.tokenFilePath = "${config.xdg.stateHome}/davmail/tokens";

    # pretend to be Outlook
    oauth.clientId = "d3590ed6-52b3-4102-aeff-aad2292ab01c";
    oauth.redirectUri = "urn:ietf:wg:oauth:2.0:oob";
  };
}
