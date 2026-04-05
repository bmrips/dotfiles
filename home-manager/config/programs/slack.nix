{ config, lib, ... }:

{
  programs.slack.autostart = true;

  programs.plasma = lib.mkIf config.programs.slack.enable {
    configFile.plasmanotifyrc."Applications/slack".ShowInHistory = false;
    window-rules = [
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
  };
}
