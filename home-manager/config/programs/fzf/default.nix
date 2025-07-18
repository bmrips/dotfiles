{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.fzf;

  inherit (lib)
    concatMapAttrsStringSep
    concatStringsSep
    escapeShellArg
    flatten
    gnuCommandArgs
    gnuCommandLine
    mkIf
    readFile
    stringAsChars
    zipAttrs
    ;
  inherit (lib.shell) dirPreview subshell;

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
        text = readFile ./fzf-state.sh;
      };
    in
    "${drv}/bin/fzf-state";

  mkBindings =
    spec:
    let
      spec' = if builtins.isList spec then spec else [ spec ];
      concatenate = concatMapAttrsStringSep "," (
        event: actions: "${event}:${concatStringsSep "+" (flatten actions)}"
      );
    in
    escapeShellArg (concatenate (zipAttrs spec'));

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
      printPwd = ''echo \$(pwd | sed 's#/home/${config.home.username}#~#')/'';
    in
    "transform-prompt(${printPwd})";

  labelPreviewWithFilename = "transform-preview-label(echo ' {} ')";

  filePreviewArgs = {
    color = "always";
    number = true;
    paging = "never";
  };

  useFdForPathListings = ''
    # Path and directory completion, e.g. for `cd .config/**`
    _fzf_compgen_path() {
        ${config.programs.fd.package}/bin/fd --hidden --exclude=".git" . "$1"
    }
    _fzf_compgen_dir() {
        ${config.programs.fd.package}/bin/fd --hidden --exclude=".git" --type=directory . "$1"
    }
  '';

  setColorsDynamically =
    let
      dark = {
        bg1 = "#32302f";
        blue = "#80aa9e";
        cyan = "#8bba7f";
        green = "#b0b846";
        grey = "#928374";
        orange = "#f28534";
        yellow = "#e9b143";
      };
      light = {
        bg1 = "#f4e8be";
        blue = "#266b79";
        cyan = "#477a5b";
        green = "#72761e";
        grey = "#928374";
        orange = "#b94c07";
        yellow = "#b4730e";
      };
      colors =
        c:
        concatStringsSep "," [
          "border:${c.grey}"
          "current-bg:${c.bg1}"
          "current-fg:-1"
          "current-hl:${c.cyan}"
          "gutter:-1"
          "label:${c.orange}"
          "hl:${c.green}"
          "info:${c.cyan}"
          "marker:${c.yellow}"
          "pointer:${c.blue}"
          "prompt:${c.orange}"
        ];
    in
    ''
      if [[ $BACKGROUND = light ]]; then
        export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=${colors light}"
      else
        export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=${colors dark}"
      fi
    '';

in
mkIf cfg.enable {

  home.sessionVariables = rec {
    FZF_GREP_COMMAND = "${fzf-state} get-source grep";
    FZF_GREP_OPTS =
      let
        label = escapeShellArg " Grep ";
        batArgs = gnuCommandLine (
          filePreviewArgs
          // {
            highlight-line = "{2}";
            line-range = subshell "${fzf-state} get-visible-range {2}";
          }
        );
      in
      gnuCommandLine {
        bind = mkBindings (fzf-state-bindings {
          inherit label;
          reloadCmd = "${FZF_GREP_COMMAND} {q}";
        });
        multi = true;
        preview = escapeShellArg "${config.programs.bat.package}/bin/bat ${batArgs} {1}";
      };
  };

  programs.fzf = {
    changeDirWidgetCommand = "${fzf-state} get-source directories";

    changeDirWidgetOptions =
      let
        label = escapeShellArg " Directories ";
      in
      gnuCommandArgs {
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
        preview = dirPreview "{}";
      };

    defaultCommand =
      let
        args = gnuCommandLine {
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
      gnuCommandArgs {
        bind = bindings;
        border = "top";
        height = "60%";
        highlight-line = true;
        layout = "reverse";
        info = "inline-right";
        prompt = escapeShellArg "${arrowHead} ";
        preview-window = "right,border,hidden";
      };

    fileWidgetCommand = "${fzf-state} get-source files";

    fileWidgetOptions =
      let
        label = escapeShellArg " Files ";
      in
      gnuCommandArgs {
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
        preview = escapeShellArg "bat ${gnuCommandLine filePreviewArgs} {}";
      };

    historyWidgetOptions = gnuCommandArgs {
      border-label = escapeShellArg " History ";
    };
  };

  programs.bash.initExtra = useFdForPathListings + setColorsDynamically;

  programs.zsh.siteFunctions.fzf-grep-widget =
    let
      grep = stringAsChars (c: if c == "\n" then "; " else c) ''
        local item
        eval $FZF_GREP_COMMAND "" | FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_GREP_OPTS" ${cfg.package}/bin/fzf --bind="change:reload($FZF_GREP_COMMAND {q} || true)" --ansi --disabled --delimiter=: | ${pkgs.gnused}/bin/sed 's/:.*$//' | ${pkgs.coreutils}/bin/uniq | while read item; do
            echo -n "''${(q)item} "
        done
        local ret=$?
        echo
        return $ret
      '';
    in
    ''
      LBUFFER="''${LBUFFER}$(${grep})"
      local ret=$?
      zle reset-prompt
      return $ret
    '';

  programs.zsh.initContent =
    useFdForPathListings
    + setColorsDynamically
    + ''
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
