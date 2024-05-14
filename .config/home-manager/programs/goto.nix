{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.goto;

  inherit (pkgs.lib) gnuCommandLine;
  inherit (pkgs.lib.shell) dirPreview subshell;

  init = ''
    source ${pkgs.goto}/share/goto.sh
  '';

in {

  options.programs.goto = {
    enable = mkEnableOption "{command}`goto`.";
    package = mkPackageOption pkgs "goto" { };
    enableFzfWidget = mkEnableOption "the {command}`fzf` widget." // {
      default = true;
    };
  };

  config = mkIf cfg.enable (mkMerge [

    {
      home.packages = [ cfg.package ];
      programs.bash.initExtra = init;
      programs.zsh.initExtra = init;
    }

    (mkIf cfg.enableFzfWidget {

      home.sessionVariables.FZF_GOTO_OPTS = gnuCommandLine {
        preview = dirPreview (subshell "echo {} | sed 's/^[a-zA-Z]* *//'");
      };

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

      programs.zsh.initExtra = ''
        # Go to `goto` bookmark
        autoload -Uz fzf-goto-widget
        zle -N fzf-goto-widget
        bindkey '^B' fzf-goto-widget
      '';

    })

  ]);

}
