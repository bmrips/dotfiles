{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.fzf;

  inherit (lib)
    concatStringsSep
    escapeShellArg
    gnuCommandArgs
    gnuCommandLine
    mkIf
    readFile
    stringAsChars
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

  fzf-state-keybindings =
    reloadCmd:
    escapeShellArg (
      concatStringsSep "," [
        "alt-f:execute(${fzf-state} toggle follow-symlinks)+reload(${reloadCmd})"
        "alt-h:execute(${fzf-state} toggle show-hidden-files)+reload(${reloadCmd})"
        "alt-i:execute(${fzf-state} toggle show-ignored-files)+reload(${reloadCmd})"
      ]
    );

  filePreviewArgs = {
    plain = true;
    color = "always";
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

in
mkIf cfg.enable {

  home.sessionVariables = rec {
    FZF_GREP_COMMAND = "${fzf-state} get-source grep";
    FZF_GREP_OPTS =
      let
        batArgs = gnuCommandLine (
          filePreviewArgs
          // {
            line-range = subshell "${fzf-state} context {2}: --highlight-line={2} {1}";
          }
        );
      in
      gnuCommandLine {
        bind = fzf-state-keybindings "${FZF_GREP_COMMAND} {q}";
        multi = true;
        preview = escapeShellArg "${config.programs.bat.package}/bin/bat ${batArgs} {1}";
      };
  };

  programs.fzf = {
    changeDirWidgetCommand = "${fzf-state} get-source directories";

    changeDirWidgetOptions = gnuCommandArgs {
      bind = fzf-state-keybindings cfg.changeDirWidgetCommand;
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
        keybindings = escapeShellArg (
          concatStringsSep "," [
            "alt-[:change-preview-window(nohidden,down|nohidden,right|nohidden,up|nohidden,left)"
            "alt-]:change-preview-window(nohidden,down|nohidden,left|nohidden,up|nohidden,right)"
            "alt-j:preview-half-page-down"
            "alt-k:preview-half-page-up"
            "alt-p:toggle-preview"
            "alt-w:toggle-preview-wrap"
            "ctrl-a:toggle-all"
            "ctrl-alt-j:preview-down"
            "ctrl-alt-k:preview-up"
            "ctrl-b:half-page-up"
            "ctrl-f:half-page-down"
          ]
        );
      in
      gnuCommandArgs {
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

    fileWidgetCommand = "${fzf-state} get-source files";

    fileWidgetOptions = gnuCommandArgs {
      bind = fzf-state-keybindings cfg.fileWidgetCommand;
      preview = escapeShellArg "bat ${gnuCommandLine filePreviewArgs} {}";
    };
  };

  programs.bash.initExtra = useFdForPathListings;

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
