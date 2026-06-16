{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkMerge [

  (import ../nixpkgs)

  {
    assertions = [
      {
        assertion = !config.submoduleSupport.enable;
        message = "This profile only available on standalone installations.";
      }
    ];

    home.shellAliases.hm = "home-manager";

    i18n.glibcLocales = pkgs.glibcLocales.override {
      allLocales = false;
      locales = [
        "C.UTF-8/UTF-8"
        "de_DE.UTF-8/UTF-8"
        "en_US.UTF-8/UTF-8"
      ];
    };

    nix.package = pkgs.nix;

    programs.home-manager.enable = true;

    services.home-manager.autoExpire = {
      enable = true;
      frequency = "weekly";
      timestamp = "-30 days";
      store.cleanup = true;
      store.options = "--delete-older-than 30d";
    };
  }
]
