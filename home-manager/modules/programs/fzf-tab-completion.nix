{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.fzf-tab-completion;

in
{
  meta.maintainers = [ lib.maintainers.bmrips ];

  options.programs.fzf-tab-completion = {

    enable = lib.mkEnableOption "fzf-tab-completion.";

    package = lib.mkPackageOption pkgs "fzf-tab-completion" { };

    fzfOptions = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
      description = "Options for fzf, set through {env}`FZF_COMPLETION_OPTS`";
      example.height = "60%";
    };

    prompt = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      description = "The search prompt prefix; set through {env}`FZF_TAB_COMPLETION_PROMPT`";
      example = "❯ ";
    };

    bashIntegration = {
      enable = lib.hm.shell.mkBashIntegrationOption { inherit config; };
      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra configuration lines to add verbatim to {file}`~/.bashrc`
        '';
        example = /* bash */ ''
          _fzf_bash_completion_loading_msg() { echo "''${PS1@P}''${READLINE_LINE}" | tail -n1; }
        '';
      };
    };

    nodeIntegration.enable = lib.mkEnableOption "Node integration." // {
      default = true;
    };

    python3Integration.enable = lib.mkEnableOption "Python3 integration." // {
      default = true;
    };

    readlineIntegration = {
      enable = lib.mkEnableOption "readline integration." // {
        default = !pkgs.stdenv.hostPlatform.isAarch;
        defaultText = "!pkgs.stdenv.hostPlatform.isAarch";
      };
      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra configuration lines to add verbatim to {file}`~/.inputrc`
        '';
      };
    };

    zshIntegration = {
      enable = lib.hm.shell.mkZshIntegrationOption { inherit config; };
      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra configuration lines to add verbatim to {file}`~/.zshrc`
        '';
        example = /* bash */ ''
          # accept and retrigger completion when pressing / when completing cd
          zstyle ':completion::*:cd:*' fzf-completion-keybindings /:accept:'repeat-fzf-completion'
        '';
      };
    };

  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [

      {
        assertions = [
          {
            assertion = cfg.readlineIntegration.enable -> !pkgs.stdenv.hostPlatform.isAarch;
            message = "fzf-tab-completion: readline integration is only available on non-ARM platforms";
          }
        ];

        home.packages = [
          cfg.package
          pkgs.fzf
          pkgs.gawk
          pkgs.gnugrep
        ];

        home.sessionVariables = {
          FZF_COMPLETION_OPTS = lib.mkIf (cfg.fzfOptions != { }) (lib.gnuCommand.line cfg.fzfOptions);
          FZF_TAB_COMPLETION_PROMPT = lib.mkIf (cfg.prompt != null) cfg.prompt;
        };

        home.shellAliases.node = lib.mkIf cfg.nodeIntegration.enable /* bash */ ''
          node -r ${cfg.package}/share/fzf-tab-completion/fzf-node-completion.js
        '';

        home.file.".pythonstartup" = lib.mkIf cfg.python3Integration.enable {
          text = /* python */ ''
            with open('${cfg.package}/share/fzf-tab-completion/fzf_python_completion.py') as file:
                exec(file.read())
          '';
        };

        programs.bash.initExtra =
          lib.mkIf (cfg.bashIntegration.enable && config.programs.bash.enableCompletion)
            (
              /* bash */ ''
                source ${cfg.package}/share/fzf-tab-completion/fzf-bash-completion.sh
                bind -x '"\t": fzf_bash_completion'
              ''
              + cfg.bashIntegration.extraConfig
            );

        programs.zsh.completionInit = lib.mkIf cfg.zshIntegration.enable (
          /* bash */ ''
            source ${cfg.package}/share/fzf-tab-completion/fzf-zsh-completion.sh
          ''
          + cfg.zshIntegration.extraConfig
        );
      }

      (lib.mkIf cfg.readlineIntegration.enable {
        home.sessionVariables.LD_PRELOAD = "${pkgs.rl_custom_function}/lib/librl_custom_function.so";
        programs.readline.extraConfig = ''
          $include function rl_custom_complete ${cfg.package}/lib/librl_custom_complete.so
          "\t": rl_custom_complete
        ''
        + cfg.readlineIntegration.extraConfig;
      })

    ]
  );

}
