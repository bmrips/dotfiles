{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    gnuCommandLine
    hm
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
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
      example.height = "60%";
    };

    prompt = mkOption {
      type = with types; nullOr str;
      default = null;
      description = "The search prompt prefix; set through {env}`FZF_TAB_COMPLETION_PROMPT`";
      example = "❯ ";
    };

    bashIntegration = {
      enable = hm.shell.mkBashIntegrationOption { inherit config; };
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration lines to add verbatim to {file}`~/.bashrc`
        '';
        example = ''
          _fzf_bash_completion_loading_msg() { echo "''${PS1@P}''${READLINE_LINE}" | tail -n1; }
        '';
      };
    };

    nodeIntegration.enable = mkEnableOption "Node integration." // {
      default = true;
    };

    python3Integration.enable = mkEnableOption "Python3 integration." // {
      default = true;
    };

    readlineIntegration = {
      enable = mkEnableOption "readline integration." // {
        default = true;
      };
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration lines to add verbatim to {file}`~/.inputrc`
        '';
      };
    };

    zshIntegration = {
      enable = hm.shell.mkZshIntegrationOption { inherit config; };
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration lines to add verbatim to {file}`~/.zshrc`
        '';
        example = ''
          # accept and retrigger completion when pressing / when completing cd
          zstyle ':completion::*:cd:*' fzf-completion-keybindings /:accept:'repeat-fzf-completion'
        '';
      };
    };

  };

  config = mkIf cfg.enable (mkMerge [

    {
      home.packages = [ cfg.package ];

      home.sessionVariables = {
        FZF_COMPLETION_OPTS = mkIf (cfg.fzfOptions != { }) (gnuCommandLine cfg.fzfOptions);
        FZF_TAB_COMPLETION_PROMPT = mkIf (cfg.prompt != null) cfg.prompt;
      };

      home.shellAliases.node = mkIf cfg.nodeIntegration.enable "node -r ${cfg.package}/share/fzf-tab-completion/fzf-node-completion.js";

      home.file.".pythonstartup".text = ''
        with open('${cfg.package}/share/fzf-tab-completion/fzf_python_completion.py') as file:
            exec(file.read())
      '';

      programs.bash.initExtra =
        mkIf (cfg.bashIntegration.enable && config.programs.bash.enableCompletion)
          (
            ''
              source ${cfg.package}/share/fzf-tab-completion/fzf-bash-completion.sh
              bind -x '"\t": fzf_bash_completion'
            ''
            + cfg.bashIntegration.extraConfig
          );

      programs.zsh.completionInit = mkIf cfg.zshIntegration.enable (
        ''
          source ${cfg.package}/share/fzf-tab-completion/fzf-zsh-completion.sh
        ''
        + cfg.zshIntegration.extraConfig
      );
    }

    (mkIf cfg.readlineIntegration.enable {
      home.sessionVariables.LD_PRELOAD = "${pkgs.rl_custom_function}/lib/librl_custom_function.so";
      programs.readline.extraConfig = ''
        $include function rl_custom_complete ${cfg.package}/lib/librl_custom_complete.so
        "\t": rl_custom_complete
      ''
      + cfg.readlineIntegration.extraConfig;
    })

  ]);

}
