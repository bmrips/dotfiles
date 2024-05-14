{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.cdhist;

  inherit (pkgs.lib) gnuCommandLine;
  inherit (pkgs.lib.shell) dirPreview subshell;

  init = ''eval "$(${cfg.package}/bin/cdhist --init)"'';

  hookDescription = shell:
    "a ${shell} hook that adds a directory to the history when you enter it.";

in {

  options.programs.cdhist = {
    enable = mkEnableOption "{command}`cdhist`.";
    package = mkPackageOption pkgs "cdhist" { };
    enableBashHook = mkEnableOption (hookDescription "Bash") // {
      default = true;
    };
    enableZshHook = mkEnableOption (hookDescription "Zsh") // {
      default = true;
    };
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

    (mkIf cfg.enableBashHook {
      # Record working directory changes by hooking into the prompt.
      programs.bash.initExtra = ''
        __cdhist_oldpwd="$(pwd)"

        function __cdhist_prompt_hook() {
            local retval pwd_tmp
            retval="$?"
            pwd_tmp="$(pwd)"

            if [[ $__cdhist_oldpwd != "$pwd_tmp" ]]; then
                __cdhist_oldpwd="$pwd_tmp"
                ${cfg.package}/bin/cdhist "$__cdhist_oldpwd" >/dev/null
            fi

            return "''${retval}"
        }

        if [[ ''${PROMPT_COMMAND:=} != *'__cdhist_prompt_hook'* ]]; then
            PROMPT_COMMAND="__cdhist_prompt_hook;''${PROMPT_COMMAND#;}"
        fi
      '';
    })

    (mkIf cfg.enableZshHook {
      # Record working directory changes by hooking into chpwd.
      programs.zsh.initExtra = ''
        function __cdhist_chpwd_hook() {
            ${cfg.package}/bin/cdhist "$(pwd)" >/dev/null
        }
        autoload -Uz add-zsh-hook
        add-zsh-hook chpwd __cdhist_chpwd_hook
      '';
    })

    (mkIf cfg.enableFzfWidget {

      home.sessionVariables.FZF_CDHIST_OPTS = gnuCommandLine {
        preview = dirPreview (subshell
          "echo {} | ${pkgs.gnused}/bin/sed 's#^~#${config.home.homeDirectory}#'");
      };

      programs.zsh.siteFunctions.fzf-cdhist-widget = ''
        local dir="$(${pkgs.gnused}/bin/sed "s#$HOME#~#" ${config.xdg.stateHome}/cd_history | FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_CDHIST_OPTS" ${config.programs.fzf.package}/bin/fzf | ${pkgs.gnused}/bin/sed "s#~#$HOME#")"
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
        # Go to directory in cd history
        autoload -Uz fzf-cdhist-widget
        zle -N fzf-cdhist-widget
        bindkey '^Y' fzf-cdhist-widget
      '';

    })

  ]);

}
