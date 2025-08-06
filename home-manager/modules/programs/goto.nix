{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.goto;
  init = "source ${cfg.package}/share/goto.sh";

in
{

  options.programs.goto = {
    enable = lib.mkEnableOption "{command}`goto`.";
    package = lib.mkPackageOption pkgs "goto" { };
    enableBashIntegration = lib.hm.shell.mkBashIntegrationOption { inherit config; };
    enableZshIntegration = lib.hm.shell.mkZshIntegrationOption { inherit config; };
    fzfWidgetOptions = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
      description = "Options for the fzf widget, set through {env}`FZF_GOTO_OPTS`";
      example.height = "60%";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.sessionVariables.FZF_GOTO_OPTS = lib.mkIf (cfg.fzfWidgetOptions != { }) (
      lib.gnuCommandLine cfg.fzfWidgetOptions
    );

    programs.bash.initExtra = lib.mkIf cfg.enableBashIntegration init;

    programs.zsh.initContent = lib.mkIf cfg.enableZshIntegration init;

    programs.zsh.siteFunctions.fzf-goto-widget = ''
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
  };

}
