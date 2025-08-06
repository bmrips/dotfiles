{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.goto;

in
{

  options.programs.goto.fzfWidget = {
    enable = lib.mkEnableOption "the fzf widget" // {
      default = true;
    };
    key = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "^G";
      description = "The key to which the fzf widget is bound.";
    };
    options = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
      example.height = "60%";
      description = "Options for the fzf widget, set through {env}`FZF_GOTO_OPTS`";
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables.FZF_GOTO_OPTS = lib.mkIf (cfg.fzfWidget.options != { }) (
      lib.cli.toGNUCommandLineShell { } cfg.fzfWidget.options
    );

    programs.zsh = {
      siteFunctions.fzf-goto-widget = ''
        _goto_resolve_db
        local dir="$(${pkgs.gnused}/bin/sed 's/ /:/' $GOTO_DB | column -t -s : | FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_GOTO_OPTS" ${config.programs.fzf.package}/bin/fzf | ${pkgs.gnused}/bin/sed "s/^[a-zA-Z]* *//")"
        if [[ -z "$dir" ]]; then
            zle redisplay
            return 0
        fi
        zle push-line
        BUFFER="cd -- ''${(q)dir}"
        zle accept-line
        local ret=$?
        zle reset-prompt
        return $ret
      '';
      initContent = ''
        zle -N fzf-goto-widget
        bindkey '${cfg.fzfWidget.key}' fzf-goto-widget
      '';
    };
  };

}
