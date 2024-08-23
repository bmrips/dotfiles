{ config, lib, pkgs, ... }:

with lib;

{
  options.profiles.standalone.enable = mkEnableOption "the standalone profile";

  config = mkIf config.profiles.standalone.enable ({

    i18n.glibcLocales = pkgs.glibcLocales.override {
      allLocales = false;
      locales = builtins.map (l: l + "/UTF-8") ([ "C.UTF-8" "en_US.UTF-8" ]
        ++ unique (attrValues config.i18n.extraLocaleSettings));
    };

    nix.package = pkgs.nix;

    serices.home-manager.autoUpgrade.enable = true;

  });
}
