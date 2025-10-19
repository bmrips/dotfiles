{ config, lib, ... }:

{
  programs.signal-desktop.autostart = true;

  programs.plasma.window-rules = lib.mkIf config.programs.signal-desktop.enable [
    {
      description = "Signal";
      match.window-class = {
        match-whole = false;
        value = "signal";
      };
      apply = {
        maximizehoriz = false;
        maximizevert = false;
        placement.apply = "force";
        placement.value = 5;
        size.value = "780,556";
      };
    }
  ];
}
