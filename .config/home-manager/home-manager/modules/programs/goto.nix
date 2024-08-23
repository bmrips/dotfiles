{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.goto;

  init = ''
    source ${pkgs.goto}/share/goto.sh
  '';

in {

  options.programs.goto = {
    enable = mkEnableOption "{command}`goto`.";
    package = mkPackageOption pkgs "goto" { };
  };

  config = mkIf cfg.enable {

    home.packages = [ cfg.package ];

    programs.bash.initExtra = init;

    programs.zsh.initExtra = init;

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
