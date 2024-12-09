{ config, lib, ... }:

let inherit (lib) mkIf;

in {
  programs.keepassxc.autostart = true;

  programs.plasma.window-rules = mkIf config.programs.keepassxc.enable [{
    description = "KeePassXC";
    match.window-class.value = "keepassxc org.keepassxc.KeePassXC";
    apply = {
      ignoregeometry.value = true;
      maximizehoriz = false;
      maximizevert = false;
      placement.apply = "force";
      placement.value = 5; # centered
      size.value = "600,528";
    };
  }];
}
