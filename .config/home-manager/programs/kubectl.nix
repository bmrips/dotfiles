{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.kubectl;

in {
  options.programs.kubectl.enable = mkEnableOption "{command}`kubectl`";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ kubectl kubectx yq-go ];

    home.shellAliases.k = "kubectl";

    programs.starship.settings.kubernetes.disabled = false;

    programs.zsh = {
      siteFunctions = {
        fzf-kubectx-widget = ''
          zle push-line
          BUFFER="kubectx"
          zle accept-line
          local ret=$?
          zle reset-prompt
          return $ret
        '';
        fzf-kubens-widget = ''
          zle push-line
          BUFFER="kubens"
          zle accept-line
          local ret=$?
          zle reset-prompt
          return $ret
        '';
      };
      initExtra = ''
        # Switch Kubernetes context
        autoload -Uz fzf-kubectx-widget
        zle -N fzf-kubectx-widget
        bindkey '^Bc' fzf-kubectx-widget

        # Switch Kubernetes namespace
        autoload -Uz fzf-kubens-widget
        zle -N fzf-kubens-widget
        bindkey '^Bn' fzf-kubens-widget
      '';
    };
  };
}
