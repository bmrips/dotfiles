{ config, lib, ... }:

{
  programs.slack.autostart = true;

  programs.plasma.window-rules = lib.mkIf config.programs.slack.enable [
    {
      description = "Slack";
      match.window-class = {
        match-whole = false;
        value = "Slack";
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
