{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.cdhist;
  init = ''eval "$(${cfg.package}/bin/cdhist --init)"'';
  hookDescription = shell:
    "a ${shell} hook that adds a directory to the history when you enter it";

in {

  options.programs.cdhist = {
    enable = mkEnableOption "{command}`cdhist`";
    package = mkPackageOption pkgs "cdhist" { };
    enableBashHook = mkEnableOption (hookDescription "Bash") // {
      default = true;
    };
    enableZshHook = mkEnableOption (hookDescription "Zsh") // {
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

  ]);

}
