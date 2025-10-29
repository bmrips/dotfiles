{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.fzf;

  fzf-state =
    let
      drv = pkgs.writeShellApplication {
        name = "fzf-state";
        runtimeInputs = with pkgs; [
          coreutils
          fd
          ripgrep
        ];
        bashOptions = [
          "errexit"
          "pipefail"
        ];
        text = lib.readFile ./state.sh;
      };
    in
    lib.getExe drv;

  mkBindings =
    spec:
    let
      spec' = if builtins.isList spec then spec else [ spec ];
      concatenate = lib.concatMapAttrsStringSep "," (
        event: actions: "${event}:${lib.concatStringsSep "+" (lib.flatten actions)}"
      );
    in
    lib.escapeShellArg (concatenate (lib.zipAttrs spec'));

  fzf-state-bindings =
    { label, reloadCmd }:
    let
      showStateIcons = l: "transform-border-label(${fzf-state} get-label ${l})";
      action = opt: [
        "execute(${fzf-state} toggle ${opt})"
        (showStateIcons label)
        "reload(${reloadCmd})"
      ];
    in
    {
      start = showStateIcons label;
      alt-f = action "follow-symlinks";
      alt-h = action "show-hidden-files";
      alt-i = action "show-ignored-files";
    };

  setWorkdirAsPrompt =
    let
      printPwd = /* bash */ ''echo \$(pwd | sed 's#${config.home.homeDirectory}#~#')/'';
    in
    "transform-prompt(${printPwd})";

  labelPreviewWithFilename = "transform-preview-label(echo ' {} ')";

  filePreviewArgs = {
    color = "always";
    number = true;
    paging = "never";
  };

  useFdForPathListings = /* bash */ ''
    # Path and directory completion, e.g. for `cd .config/**`
    _fzf_compgen_path() {
        ${lib.getExe config.programs.fd.package} --hidden --exclude=".git" . "$1"
    }
    _fzf_compgen_dir() {
        ${lib.getExe config.programs.fd.package} --hidden --exclude=".git" --type=directory . "$1"
    }
  '';

  setColorsDynamically =
    let
      colors =
        darkness:
        with (lib.gruvbox_material.scheme darkness).withHashtag;
        lib.concatStringsSep "," [
          "border:${base03}"
          "current-bg:${base01}"
          "current-fg:-1"
          "current-hl:${cyan}"
          "gutter:${base00}"
          "label:${orange}"
          "hl:${green}"
          "info:${cyan}"
          "marker:${yellow}"
          "pointer:${blue}"
          "prompt:${orange}"
        ];
    in
    /* bash */ ''
      if [[ $BACKGROUND = light ]]; then
        export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=${colors "light"}"
      else
        export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=${colors "dark"}"
      fi
    '';

in
lib.mkIf cfg.enable {

  home.sessionVariables = rec {
    FZF_GREP_COMMAND = "${fzf-state} get-source grep";
    FZF_GREP_OPTS =
      let
        label = lib.escapeShellArg " Grep ";
        batArgs = lib.gnuCommand.line (
          filePreviewArgs
          // {
            highlight-line = "{2}";
            line-range = lib.shell.subshell "${fzf-state} get-visible-range {2}";
          }
        );
      in
      lib.gnuCommand.line {
        bind = mkBindings (fzf-state-bindings {
          inherit label;
          reloadCmd = "${FZF_GREP_COMMAND} {q}";
        });
        multi = true;
        preview = lib.escapeShellArg "${lib.getExe config.programs.bat.package} ${batArgs} {1}";
      };
  };

  programs.fzf = {
    changeDirWidgetCommand = "${fzf-state} get-source directories";

    changeDirWidgetOptions =
      let
        label = lib.escapeShellArg " Directories ";
      in
      lib.gnuCommand.args {
        bind = mkBindings [
          {
            start = [ setWorkdirAsPrompt ];
            focus = labelPreviewWithFilename;
          }
          (fzf-state-bindings {
            inherit label;
            reloadCmd = cfg.changeDirWidgetCommand;
          })
        ];
        preview = lib.shell.dirPreview "{}";
      };

    defaultCommand =
      let
        args = lib.gnuCommand.line {
          hidden = true;
          type = "file";
        };
      in
      "fd ${args}";

    defaultOptions =
      let
        arrowHead = "❯";
        bindings = mkBindings {
          "alt-[" = "change-preview-window(nohidden,down|nohidden,right|nohidden,up|nohidden,left)";
          "alt-]" = "change-preview-window(nohidden,down|nohidden,left|nohidden,up|nohidden,right)";
          alt-j = "preview-half-page-down";
          alt-k = "preview-half-page-up";
          alt-p = [
            "toggle-preview"
            labelPreviewWithFilename
          ];
          alt-w = "toggle-preview-wrap";
          change = "first"; # focus the first element when the query is changed
          ctrl-a = "toggle-all";
          ctrl-alt-j = "preview-down";
          ctrl-alt-k = "preview-up";
          ctrl-b = "half-page-up";
          ctrl-f = "half-page-down";
        };
      in
      lib.gnuCommand.args {
        bind = bindings;
        border = "top";
        height = "60%";
        highlight-line = true;
        layout = "reverse";
        info = "inline-right";
        prompt = lib.escapeShellArg "${arrowHead} ";
        preview-window = "right,border,hidden";
      };

    fileWidgetCommand = "${fzf-state} get-source files";

    fileWidgetOptions =
      let
        label = lib.escapeShellArg " Files ";
      in
      lib.gnuCommand.args {
        bind = mkBindings [
          {
            start = setWorkdirAsPrompt;
            focus = labelPreviewWithFilename;
          }
          (fzf-state-bindings {
            inherit label;
            reloadCmd = cfg.fileWidgetCommand;
          })
        ];
        preview = lib.escapeShellArg "bat ${lib.gnuCommand.line filePreviewArgs} {}";
      };

    historyWidgetOptions = lib.gnuCommand.args {
      border-label = lib.escapeShellArg " History ";
    };
  };

  programs.bash.initExtra = useFdForPathListings + setColorsDynamically;

  programs.zsh.siteFunctions.fzf-grep-widget =
    let
      grep = lib.stringAsChars (c: if c == "\n" then "; " else c) /* bash */ ''
        local item
        eval $FZF_GREP_COMMAND "" | FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_GREP_OPTS" ${lib.getExe cfg.package} --bind="change:reload($FZF_GREP_COMMAND {q} || true)" --ansi --disabled --delimiter=: | ${pkgs.gnused}/bin/sed 's/:.*$//' | ${pkgs.coreutils}/bin/uniq | while read item; do
            echo -n "''${(q)item} "
        done
        local ret=$?
        echo
        return $ret
      '';
    in
    /* bash */ ''
      LBUFFER="''${LBUFFER}$(${grep})"
      local ret=$?
      zle reset-prompt
      return $ret
    '';

  programs.zsh.initContent =
    useFdForPathListings
    + setColorsDynamically
    + /* bash */ ''
      # Select files with Ctrl+Space, history with Ctrl+/, directories with Ctrl+T
      bindkey '^ ' fzf-file-widget
      bindkey '^_' fzf-history-widget
      bindkey '^T' fzf-cd-widget

      bindkey -M vicmd '^R' redo  # restore redo

      # Preview when completing env vars (note: only works for exported variables).
      # Eval twice, first to unescape the string, second to expand the $variable.
      zstyle ':completion::*:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-completion-opts --preview='eval eval echo {1}' --preview-window=wrap

      # Interactive grep
      zle -N fzf-grep-widget
      bindkey '^G' fzf-grep-widget
    '';

}
