{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.fzf;

  inherit (pkgs.lib) gnuCommandArgs gnuCommandLine;
  inherit (pkgs.lib.shell) dirPreview subshell;
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  fzf-state-keybindings = reloadCmd:
    escapeShellArg (concatStringsSep "," [
      "alt-h:execute(fzf-state toggle hide-hidden-files)+reload(${reloadCmd})"
      "alt-i:execute(fzf-state toggle show-ignored-files)+reload(${reloadCmd})"
    ]);

  filePreviewArgs = {
    plain = true;
    color = "always";
    paging = "never";
  };

  useFdForPathListings = ''
    # Path and directory completion, e.g. for `cd .config/**`
    _fzf_compgen_path() {
        ${config.programs.fd.package}/bin/fd --follow --hidden --exclude=".git" . "$1"
    }
    _fzf_compgen_dir() {
        ${config.programs.fd.package}/bin/fd --follow --hidden --exclude=".git" --type=directory . "$1"
    }
  '';

  plainArrowInTTY = ''
    # use ASCII arrow head in non-pseudo TTYs
    if [[ $TTY == /dev/${if isDarwin then "console" else "tty*"} ]]; then
        export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --marker='>' --pointer='>' --prompt='> '"
    fi
  '';

in mkIf cfg.enable {

  home.sessionVariables = rec {
    FZF_COMPLETION_OPTS = gnuCommandLine { height = "60%"; };
    FZF_GREP_COMMAND = "fzf-state get-source grep";
    FZF_GREP_OPTS = let
      batArgs = gnuCommandLine (filePreviewArgs // {
        line-range = subshell "fzf-state context {2}: --highlight-line={2} {1}";
      });
    in gnuCommandLine {
      bind = fzf-state-keybindings "${FZF_GREP_COMMAND} {q}";
      multi = true;
      preview =
        escapeShellArg "${config.programs.bat.package}/bin/bat ${batArgs} {1}";
    };
  };

  programs.fzf = {
    changeDirWidgetCommand = "fzf-state get-source directories";

    changeDirWidgetOptions = gnuCommandArgs {
      bind = fzf-state-keybindings cfg.changeDirWidgetCommand;
      preview = dirPreview "{}";
    };

    defaultCommand = let
      args = gnuCommandLine {
        follow = true;
        hidden = true;
        type = "file";
      };
    in "fd ${args}";

    defaultOptions = let
      arrowHead = "❯";
      keybindings = escapeShellArg (concatStringsSep "," [
        "ctrl-f:half-page-down"
        "ctrl-b:half-page-up"
        "alt-a:toggle-all"
        "f3:toggle-preview-wrap"
        "f4:toggle-preview"
        "f5:change-preview-window(nohidden,down|nohidden,left|nohidden,up|nohidden,right)"
      ]);
    in gnuCommandArgs {
      bind = keybindings;
      border = "horizontal";
      color = "16,info:8,border:8";
      height = "60%";
      layout = "reverse";
      marker = arrowHead;
      pointer = arrowHead;
      prompt = escapeShellArg "${arrowHead} ";
      preview-window = "right,border,hidden";
    };

    fileWidgetCommand = "fzf-state get-source files";

    fileWidgetOptions = gnuCommandArgs {
      bind = fzf-state-keybindings cfg.fileWidgetCommand;
      preview = escapeShellArg "bat ${gnuCommandLine filePreviewArgs} {}";
    };
  };

  programs.bash.initExtra = useFdForPathListings + plainArrowInTTY;

  programs.zsh.siteFunctions.fzf-grep-widget = let
    grep = stringAsChars (c: if c == "\n" then "; " else c) ''
      local item
      eval $FZF_GREP_COMMAND "" | FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_GREP_OPTS" ${cfg.package}/bin/fzf --bind="change:reload($FZF_GREP_COMMAND {q} || true)" --ansi --disabled --delimiter=: | ${pkgs.gnused}/bin/sed 's/:.*$//' | ${pkgs.coreutils}/bin/uniq | while read item; do
          echo -n "''${(q)item} "
      done
      local ret=$?
      echo
      return $ret
    '';
  in ''
    LBUFFER="''${LBUFFER}$(${grep})"
    local ret=$?
    zle reset-prompt
    return $ret
  '';

  programs.zsh.initExtra = useFdForPathListings + plainArrowInTTY + ''
    # Select files with Ctrl+Space, history with Ctrl+/, directories with Ctrl+T
    bindkey '^ ' fzf-file-widget
    bindkey '^_' fzf-history-widget
    bindkey '^T' fzf-cd-widget

    bindkey -M vicmd '^R' redo  # restore redo

    # Preview when completing env vars (note: only works for exported variables).
    # Eval twice, first to unescape the string, second to expand the $variable.
    zstyle ':completion::*:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-completion-opts --preview='eval eval echo {1}' --preview-window=wrap

    # Interactive grep
    autoload -Uz fzf-grep-widget
    zle -N fzf-grep-widget
    bindkey '^G' fzf-grep-widget
  '';

}
