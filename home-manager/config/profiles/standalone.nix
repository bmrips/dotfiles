{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.profiles.standalone.enable = lib.mkEnableOption "the standalone profile.";

  config = lib.mkIf config.profiles.standalone.enable (
    lib.mkMerge [
      (import ../../../nixpkgs)
      {
        assertions = [
          {
            assertion = !config.submoduleSupport.enable;
            message = "This profile only available on standalone installations.";
          }
        ];

        i18n.glibcLocales = pkgs.glibcLocales.override {
          allLocales = false;
          locales = [
            "C.UTF-8/UTF-8"
            "en_US.UTF-8/UTF-8"
          ];
        };

        nix.package = pkgs.nix;

        services.home-manager.autoUpgrade.enable = true;
      }
    ]
  );
}
