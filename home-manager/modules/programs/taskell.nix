{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    concatLines
    concatMapAttrs
    generators
    hasInfix
    isAttrs
    isBool
    isString
    mapAttrs
    mapAttrs'
    mapAttrsToList
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    nameValuePair
    types
    ;
  cfg = config.programs.taskell;

  # Taskell assumes that string values are quoted only if the contain spaces
  # (exception: `bindings.ini`). Furthermore, boolean values must not be given
  # as integers but verbatim.
  mkKeyValue =
    k: v:
    let
      v' =
        if isString v then
          (if hasInfix " " v then ''"${v}"'' else v)
        else if isBool v then
          (if v then "true" else "false")
        else
          toString v;
    in
    "${k} = ${v'}";

  toIni = generators.toINI { inherit mkKeyValue; };

  # Flattens an attrset, i.e. `flattenAttrs { a.b = 0; } = { "a.b" = 0 }`.
  flattenAttrs = concatMapAttrs (
    n: v:
    if !(isAttrs v) then
      {
        ${n} = v;
      }
    else
      mapAttrs' (n': v': nameValuePair "${n}.${n'}" v') (flattenAttrs v)
  );

  flatten3rdLevel = mapAttrs (n: v: if !(isAttrs v) then v else flattenAttrs v);

in
{

  options.programs.taskell = {

    enable = mkEnableOption "{command}`taskell`.";

    package = mkPackageOption pkgs "taskell" { };

    bindings = mkOption {
      type = with types; attrsOf str;
      default = { };
      description = "Key bindings for {command}`taskell`.";
      example = {
        new = "n";
      };
    };

    config = mkOption {
      type =
        with types;
        let
          scalar = oneOf [
            bool
            int
            str
          ];
        in
        attrsOf (either scalar (attrsOf scalar));
      default = { };
      description = "Config for {command}`taskell`.";
      example = {
        layout.statusbar = true;
      };
    };

    template = mkOption {
      type = with types; nullOr lines;
      default = null;
      description = "Template for the `taskell.md` file.";
      example = ''
        ## To Do
        ## Done
      '';
    };

    theme = mkOption {
      type =
        with types;
        let
          t = attrsOf (either str t);
        in
        t;
      default = { };
      description = "Theme for {command}`taskell`.";
      example = {
        other.statusBar.fg = "default";
      };
    };

  };

  config = mkIf cfg.enable {

    home.packages = [ cfg.package ];

    xdg.configFile = {
      # `bindings.ini` does not have any nesting, hence we can not use
      # `generators.toINI` here. Additionally, taskell assumes that even string
      # values containing spaces to not be quoted.
      "taskell/bindings.ini" = mkIf (cfg.bindings != { }) {
        text = concatLines (mapAttrsToList (k: v: "${k} = ${v}") cfg.bindings);
      };

      "taskell/config.ini" = mkIf (cfg.config != { }) { text = toIni cfg.config; };

      "taskell/template.md" = mkIf (cfg.template != null) { text = cfg.template; };

      # `theme.ini` is nested three levels deep which `generators.toINI` can not
      # handle. Hence, the third level needs to be flattened (see
      # `flattenAttrs`).
      "taskell/theme.ini" = mkIf (cfg.theme != { }) { text = toIni (flatten3rdLevel cfg.theme); };
    };

  };

}
