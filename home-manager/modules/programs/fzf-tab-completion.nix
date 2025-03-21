{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    gnuCommandLine
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optionalString
    types
    ;
  cfg = config.programs.fzf-tab-completion;

in
{

  options.programs.fzf-tab-completion = {

    enable = mkEnableOption "fzf-tab-completion.";

    package = mkPackageOption pkgs "fzf-tab-completion" { };

    fzfOptions = mkOption {
      type = with types; attrsOf str;
      default = { };
      description = "Options for fzf, set through {env}`FZF_COMPLETION_OPTS`";
      example = {
        height = "60%";
      };
    };

    prompt = mkOption {
      type = with types; nullOr str;
      default = null;
      description = "The search prompt; set through {env}`FZF_TAB_COMPLETION_PROMPT`";
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

  config = mkIf cfg.enable {

    home.packages = [ cfg.package ];

    home.sessionVariables = {
      FZF_COMPLETION_OPTS = mkIf (cfg.fzfOptions != { }) (gnuCommandLine cfg.fzfOptions);
      FZF_TAB_COMPLETION_PROMPT = mkIf (cfg.prompt != null) cfg.prompt;
    };

    programs.bash.initExtra = mkIf config.programs.bash.enableCompletion (
      ''
        source ${cfg.package}/share/fzf-tab-completion/bash/fzf-bash-completion.sh
        bind -x '"\t": fzf_bash_completion'
      ''
      + optionalString (cfg.bashExtraConfig != null) cfg.bashExtraConfig
    );

    programs.zsh.initExtra = mkIf config.programs.zsh.enableCompletion (
      ''
        source ${cfg.package}/share/fzf-tab-completion/zsh/fzf-zsh-completion.sh
      ''
      + optionalString (cfg.zshExtraConfig != null) cfg.zshExtraConfig
    );

  };

}
