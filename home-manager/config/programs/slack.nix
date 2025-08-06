{ config, lib, ... }:

{
  programs.slack.autostart = true;

  programs.plasma.window-rules = lib.mkIf config.programs.slack.enable [
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
