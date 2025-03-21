{
  config,
  lib,
  pkgs,
  ...
}:

let
  kubectl-show-secrets = ''
    local single_secret_recipe='.data[] |= @base64d | .name = .metadata.name | pick(["name", "data"])'
    local multiple_secrets_recipe=".items | .[] |= ($single_secret_recipe)"
    local recipe

    if (($# == 1)); then
        recipe="$single_secret_recipe"
    else
        recipe="$multiple_secrets_recipe"
    fi

    ${pkgs.kubectl}/bin/kubectl get --output=yaml secret "$@" | ${pkgs.yq-go}/bin/yq "$recipe"
  '';

  kubectl-wrapper = ''
    case $1 in
      show-secrets) shift && kubectl-show-secrets "$@" ;;
      *) command ${pkgs.kubectl}/bin/kubectl "$@" ;;
    esac
  '';

in
{

  options.development.kubernetes.enable = lib.mkEnableOption "Kubernetes development tools.";

  config = lib.mkIf config.development.kubernetes.enable {

    home.packages = with pkgs; [
      kubectx
      yq-go
    ];

    home.shellAliases.k = "kubectl";

    programs.starship.settings.kubernetes.disabled = false;

    programs.bash.initExtra = ''
      # Enable `kubectl show-secrets`
      kubectl() {
        ${kubectl-wrapper}
      }
      kubectl-show-secrets() {
        ${kubectl-show-secrets}
      }
    '';

    programs.kubectl.enable = true;

    programs.zsh = {
      initExtra = ''
        # Switch Kubernetes context
        zle -N fzf-kubectx-widget
        bindkey '^Bc' fzf-kubectx-widget

        # Switch Kubernetes namespace
        zle -N fzf-kubens-widget
        bindkey '^Bn' fzf-kubens-widget
      '';
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
        inherit kubectl-show-secrets;
        kubectl = kubectl-wrapper;
      };
    };

    programs.k9s = {
      enable = true;
      settings.k9s = {
        liveViewAutoRefresh = true;
        skipLatestRevCheck = true;
        ui.logoless = true;
      };
    };

  };
}
