{ config, lib, pkgs, ... }:

with lib;

let cfg = config.fonts.jetbrains-mono;

in {

  options.fonts.jetbrains-mono = {

    enable = mkEnableOption "the JetBrains Mono font";

    package =
      mkPackageOption pkgs "JetBrains Mono" { default = "jetbrains-mono"; };

    asDefaultMonospacedFont = mkOption {
      type = with types; str;
      default = null;
      description = ''
        When not nulll, installs JetBrains Mono and configures the given variant
        it as the default monospaced font.
      '';
      example = "JetbrainsMono Medium";
    };

  };

  config = mkIf cfg.enable (mkMerge [

    { fonts.packages = [ cfg.package ]; }

    (mkIf (cfg.asDefaultMonospacedFont != null) {
      fonts.fontconfig.defaultFonts.monospace = [ cfg.asDefaultMonospacedFont ];
      services.kmscon.fonts = [{
        name = cfg.asDefaultMonospacedFont;
        package = cfg.package;
      }];
    })

  ]);

}
