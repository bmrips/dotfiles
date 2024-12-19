{ config, lib, ... }:

let
  inherit (lib) mkIf;

in
{
  programs.slack.autostart = true;

  programs.plasma.window-rules = mkIf config.programs.slack.enable [
    {
      description = "Slack";
      match = {
        window-class.value = "slack Slack";
        window-role.value = "browser-window";
      };
      apply = {
        maximizehoriz = false;
        maximizevert = false;
        placement.apply = "force";
        placement.value = 5;
      };
    }
  ];
}
