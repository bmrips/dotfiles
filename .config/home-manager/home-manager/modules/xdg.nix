{ config, lib, pkgs, ... }:

let inherit (lib) isAttrs mapAttrs' mapAttrs mkOption types;

in {

  options.xdg.autostart = mkOption {
    type = with types; attrsOf (either pathInStore (attrsOf anything));
    default = [ ];
    description = "Applications that are started automatically on login.";
    apply = mapAttrs (n: v:
      if isAttrs v then
        "${
          pkgs.makeDesktopItem (v // { name = n; })
        }/share/applications/${n}.desktop"
      else
        v);
  };

  config.xdg.configFile = mapAttrs' (name: path: {
    name = "autostart/${name}.desktop";
    value.source = path;
  }) config.xdg.autostart;

}
