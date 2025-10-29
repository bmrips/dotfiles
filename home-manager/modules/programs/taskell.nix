{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.taskell;

  # Taskell assumes that string values are quoted only if the contain spaces
  # (exception: `bindings.ini`). Furthermore, boolean values must not be given
  # as integers but verbatim.
  mkKeyValue =
    k: v:
    let
      v' =
        if lib.isString v then
          (if lib.hasInfix " " v then ''"${v}"'' else v)
        else if lib.isBool v then
          (if v then "true" else "false")
        else
          toString v;
    in
    "${k} = ${v'}";

  toIni = lib.generators.toINI { inherit mkKeyValue; };

  # Flattens an attrset, i.e. `flattenAttrs { a.b = 0; } = { "a.b" = 0 }`.
  flattenAttrs = lib.concatMapAttrs (
    n: v:
    if !(lib.isAttrs v) then
      {
        ${n} = v;
      }
    else
      lib.mapAttrs' (n': v': lib.nameValuePair "${n}.${n'}" v') (flattenAttrs v)
  );

  flatten3rdLevel = lib.mapAttrs (_: v: if !(lib.isAttrs v) then v else flattenAttrs v);

in
{

  options.programs.taskell = {

    enable = lib.mkEnableOption "{command}`taskell`";

    package = lib.mkPackageOption pkgs "taskell" { };

    bindings = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
      description = "Key bindings for {command}`taskell`.";
      example = {
        new = "n";
      };
    };

    config = lib.mkOption {
      type =
        with lib.types;
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

    template = lib.mkOption {
      type = with lib.types; nullOr lines;
      default = null;
      description = "Template for the `taskell.md` file.";
      example = ''
        ## To Do
        ## Done
      '';
    };

    theme = lib.mkOption {
      type =
        with lib.types;
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

  config = lib.mkIf cfg.enable {

    home.packages = [ cfg.package ];

    xdg.configFile = {
      # `bindings.ini` does not have any nesting, hence we can not use
      # `generators.toINI` here. Additionally, taskell assumes that even string
      # values containing spaces to not be quoted.
      "taskell/bindings.ini" = lib.mkIf (cfg.bindings != { }) {
        text = lib.concatLines (lib.mapAttrsToList (k: v: "${k} = ${v}") cfg.bindings);
      };

      "taskell/config.ini" = lib.mkIf (cfg.config != { }) { text = toIni cfg.config; };

      "taskell/template.md" = lib.mkIf (cfg.template != null) { text = cfg.template; };

      # `theme.ini` is nested three levels deep which `generators.toINI` can not
      # handle. Hence, the third level needs to be flattened (see
      # `flattenAttrs`).
      "taskell/theme.ini" = lib.mkIf (cfg.theme != { }) { text = toIni (flatten3rdLevel cfg.theme); };
    };

  };

}
