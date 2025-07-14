{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    makeBinPath
    mkMerge
    optionalString
    strings
    ;
  cfg = config.programs.zsh;

in
{
  programs.zsh = {

    defaultKeymap = "viins";

    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    autosuggestion.enable = true;

    history = rec {
      extended = true;
      ignoreSpace = false;
      path = "${config.xdg.stateHome}/zsh/history";
      save = size;
      share = false;
      size = 100000;
    };

    options = {
      auto_pushd = true;
      hist_reduce_blanks = true;
      inc_append_history_time = true;
      null_glob = true; # remove patterns without matches from argument list
      sh_word_split = true; # split fields like in Bash
    };

    shellGlobalAliases = {
      C = "| wc -l";
      G = "| rg";
      H = "| head";
      L = "| less";
      NE = "2>/dev/null";
      NO = "&>/dev/null";
      S = "| sort";
      T = "| tail";
      U = "| uniq";
      V = "| nvim";
      X = "| xargs";
    };

    completionInit = ''
      zmodload zsh/complist

      bindkey -M menuselect '^A' send-break # abort
      bindkey -M menuselect '^H' vi-backward-char # left
      bindkey -M menuselect '^J' vi-down-line-or-history # down
      bindkey -M menuselect '^K' vi-up-line-or-history # up
      bindkey -M menuselect '^L' vi-forward-char # right
      bindkey -M menuselect '^N' vi-forward-blank-word # next group
      bindkey -M menuselect '^P' vi-backward-blank-word # previous group
      bindkey -M menuselect '^T' accept-and-hold # hold
      bindkey -M menuselect '^U' undo
      bindkey -M menuselect '^Y' accept-and-infer-next-history # next

      autoload -Uz compinit
      compinit -d "${config.xdg.cacheHome}/zsh/zcompdump-$ZSH_VERSION"

      _comp_option+=(globdots)  # include hidden files in completion

      zstyle ':completion:*' menu select  # enable menu style completion

      zstyle ':completion:*' use-cache yes
      zstyle ':completion:*' cache-path '${config.xdg.cacheHome}/zsh/completion'

      zstyle ':completion:*' verbose yes
      zstyle ':completion:*:descriptions' format "$fg[yellow]%B--- %d%b"
      zstyle ':completion:*:messages' format '%d'
      zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
      zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
      zstyle ':completion:*' group-name '''

      zstyle ':completion:*' keep-prefix yes  # keep a prefix containing ~ or a param
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}  # colorized completion
      zstyle ':completion:*' squeeze-slashes yes  # remove trailing slashes
    '';

    siteFunctions = {
      cd_parent = ''
        zle push-line
        BUFFER="cd .."
        zle accept-line
        local ret=$?
        zle reset-prompt
        return $ret
      '';
      cd_undo = ''
        zle push-line
        BUFFER="popd"
        zle accept-line
        local ret=$?
        zle reset-prompt
        return $ret
      '';
      common-commands = ''
        PATH='${
          makeBinPath (
            with pkgs;
            [
              coreutils
              gnused
            ]
          )
        }' \
        cat '${cfg.history.path}' |
          sed ': merge;/\\$/{N;s/\\\n//;b merge};s/^[^;]*;//' |
          cut --delimiter=" " --fields=1 |
          sort |
          uniq --count |
          sort --numeric-sort --reverse |
          head --lines=15
      '';
      edit-command-line-and-restore-cursor = ''
        edit-command-line
        bar_cursor
      '';
      rationalise-dot = ''
        if [[ $LBUFFER == *[\ /].. || $LBUFFER == .. ]]; then
          LBUFFER+=/..
        else
          LBUFFER+=.
        fi
      '';
    };

    initContent = mkMerge [

      ''
        # Display the cursor as a bar
        autoload -Uz add-zsh-hook add-zsh-hook-widget

        function bar_cursor() {
            echo -ne "\e[6 q"
        }

        function block_cursor() {
            echo -ne "\e[2 q"
        }

        function underline_cursor() {
            echo -ne "\e[4 q"
        }

        function zle-line-init() {
            bar_cursor
        }
        zle -N zle-line-init

        add-zsh-hook preexec block_cursor

        # Edit the command line with $EDITOR
        autoload -Uz edit-command-line
        zle -N edit-command-line-and-restore-cursor
        bindkey          '^V' edit-command-line-and-restore-cursor
        bindkey -M vicmd '^V' edit-command-line-and-restore-cursor

        # Help for builtin commands
        unalias run-help
        autoload -Uz run-help

        # Go upwards quickly by typing sequences of dots
        zle -N rationalise-dot
        bindkey . rationalise-dot

        # Next/previous history item which the command line is a prefix of
        autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
        zle -N up-line-or-beginning-search
        zle -N down-line-or-beginning-search
        bindkey '^J' down-line-or-beginning-search
        bindkey '^K' up-line-or-beginning-search

        # Autosuggestion keybindings
        bindkey '^E' forward-word
        bindkey '^F' autosuggest-execute

        # Go back with <C-o>
        zle -N cd_undo
        bindkey '^O' cd_undo

        # Go to parent dir with <C-p>
        zle -N cd_parent
        bindkey '^P' cd_parent

        # Fix the home, end and delete keys
        bindkey '^[[H' beginning-of-line
        bindkey '^[[F' end-of-line
        bindkey '^[[3~' delete-char
        bindkey '^[3;5~' delete-char
      ''

      (optionalString (strings.hasPrefix "vi" cfg.defaultKeymap) ''
        bindkey -M viins jk vi-cmd-mode
        bindkey -M vicmd H vi-beginning-of-line
        bindkey -M vicmd L vi-end-of-line

        # Adapt the cursor shape to the mode
        function zle-keymap-select {
            case $KEYMAP in
                viins|main) bar_cursor ;;
                viopp)      underline_cursor ;;
                *)          block_cursor ;;
            esac
        }
        zle -N zle-keymap-select

        # Increment with <C-a>
        autoload -Uz incarg
        zle -N incarg
        bindkey -M vicmd '^A' incarg

        # Text operators for quotes and blocks.
        autoload -Uz select-bracketed select-quoted
        zle -N select-quoted
        zle -N select-bracketed
        for km in viopp visual; do
            for c in {a,i}''${(s..)^:-q\'\"\`}; do
                bindkey -M $km -- $c select-quoted
            done
            for c in {a,i}''${(s..)^:-'bB()[]{}<>'}; do
                bindkey -M $km -- $c select-bracketed
            done
        done

        # vim-surround
        autoload -Uz surround
        zle -N delete-surround surround
        zle -N add-surround surround
        zle -N change-surround surround
        bindkey -a 'cz' change-surround
        bindkey -a 'dz' delete-surround
        bindkey -a 'yz' add-surround
        bindkey -M visual 'Z' add-surround
      '')

    ];

  };

}
