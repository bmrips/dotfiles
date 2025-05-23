{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    attrValues
    mkEnableOption
    mkIf
    mkMerge
    unique
    ;

in
{
  options.profiles.standalone.enable = mkEnableOption "the standalone profile.";

  config = mkIf config.profiles.standalone.enable (mkMerge [
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
        locales = builtins.map (l: l + "/UTF-8") (
          [
            "C.UTF-8"
            "en_US.UTF-8"
          ]
          ++ unique (attrValues config.i18n.extraLocaleSettings)
        );
      };

      nix.gc = {
        automatic = true;
        options = "--delete-older-than 30d";
        randomizedDelaySec = "1h";
      };

      nix.package = pkgs.nix;

      services.home-manager.autoUpgrade.enable = true;
    }
  ]);
}
