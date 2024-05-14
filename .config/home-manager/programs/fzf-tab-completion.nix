{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.fzf-tab-completion;

in {

  options.programs.fzf-tab-completion = {

    enable = mkEnableOption "fzf-tab-completion";

    package = mkPackageOption pkgs "fzf-tab-completion" { };

    prompt = mkOption {
      type = with types; nullOr str;
      default = null;
      description = ''
        The search prompt; set through `FZF_TAB_COMPLETION_PROMPT`
      '';
      example = "❯ ";
    };

    bashExtraConfig = mkOption {
      type = with types; nullOr lines;
      default = null;
      description = ''
        Extra configuration lines to add verbatim to {file}`~/.bashrc`
      '';
      example = ''
        _fzf_bash_completion_loading_msg() { echo "''${PS1@P}''${READLINE_LINE}" | tail -n1; }
      '';
    };

    zshExtraConfig = mkOption {
      type = with types; nullOr lines;
      default = null;
      description = ''
        Extra configuration lines to add verbatim to {file}`~/.zshrc`
      '';
      example = ''
        # accept and retrigger completion when pressing / when completing cd
        zstyle ':completion::*:cd:*' fzf-completion-keybindings /:accept:'repeat-fzf-completion'
      '';
    };

  };

  config = mkIf cfg.enable (mkMerge [

    { home.packages = [ cfg.package ]; }

    (mkIf (cfg.prompt != null) {
      home.sessionVariables.FZF_TAB_COMPLETION_PROMPT = cfg.prompt;
    })

    (mkIf config.programs.bash.enableCompletion {
      programs.bash.initExtra = concatLines ([''
        source ${cfg.package}/share/fzf-tab-completion/bash/fzf-bash-completion.sh
        bind -x '"\t": fzf_bash_completion'
      ''] ++ optional (cfg.bashExtraConfig != null) cfg.bashExtraConfig);
    })

    (mkIf config.programs.zsh.enableCompletion {
      programs.zsh.initExtra = concatLines ([
        "source ${cfg.package}/share/fzf-tab-completion/zsh/fzf-zsh-completion.sh"
      ] ++ optional (cfg.zshExtraConfig != null) cfg.zshExtraConfig);
    })

    {
      programs.fzf-tab-completion = {
        prompt = "❯ ";
        zshExtraConfig = ''
          zstyle ':completion:*' fzf-search-display true  # search completion descriptions
          zstyle ':completion:*' fzf-completion-opts --tiebreak=chunk  # do not skew the ordering

          keys=(
              ctrl-y:accept:'repeat-fzf-completion'  # accept the completion and retrigger it
              alt-enter:accept:'zle accept-line'  # accept the completion and run it
          )
          zstyle ':completion:*' fzf-completion-keybindings "''${keys[@]}"

          # Also accept and retrigger completion when pressing / when completing cd
          zstyle ':completion::*:cd:*' fzf-completion-keybindings "''${keys[@]}" /:accept:'repeat-fzf-completion'
        '';
      };
    }

  ]);

}
