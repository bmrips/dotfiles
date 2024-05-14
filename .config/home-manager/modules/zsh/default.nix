{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.zsh;
  setOpt = name: flag: "${if flag then "setopt" else "unsetopt"} ${name}";

in {

  options.programs.zsh = {

    options = mkOption {
      type = with types; attrsOf bool;
      default = { };
      description = "Options to set or unset";
      example = { null_glob = true; };
    };

    siteFunctions = mkOption {
      type = with types; attrsOf lines;
      default = { };
      description = ''
        Functions that are added to the Zsh environment and are subject to
        {command}`autoload`ing. The key is the name and the value is the body of
        the function to be autoloaded.
      '';
      example = {
        mkcd = ''
          mkdir --parents "$1" && cd "$1"
        '';
      };
    };

    useInNixShell =
      mkEnableOption "zsh-nix-shell, i.e. to spawn Zsh in Nix shells";

  };

  config = mkMerge [

    (mkIf (cfg.options != { }) {
      programs.zsh.initExtra = concatLines (mapAttrsToList setOpt cfg.options);
    })

    (mkIf (cfg.siteFunctions != { }) {
      home.packages = mapAttrsToList
        (name: pkgs.writeTextDir "share/zsh/site-functions/${name}")
        cfg.siteFunctions;
    })

    (mkIf (cfg.useInNixShell) {
      home.packages = [ pkgs.zsh-nix-shell ];
      programs.zsh.initExtra = ''
        source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
      '';
    })

    {
      programs.zsh = {
        defaultKeymap = "viins";
        useInNixShell = true;
        syntaxHighlighting.enable = true;
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
          extended_glob = true;
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
          rationalise-dot = ''
            if [[ $LBUFFER == *[\ /].. || $LBUFFER == .. ]]; then
              LBUFFER+=/..
            else
              LBUFFER+=.
            fi
          '';
        };
        initExtraFirst = ''
          # If not running interactively, don't do anything
          [[ $- != *i* ]] && return
        '';
        initExtra = ''
          autoload -Uz edit-command-line
          zle -N edit-command-line
          bindkey          '^V' edit-command-line
          bindkey -M vicmd '^V' edit-command-line

          # Help for builtin commands
          unalias run-help
          autoload -Uz run-help

          # Go upwards quickly by typing sequences of dots
          autoload -Uz rationalise-dot
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
          bindkey '^G' autosuggest-execute

          # Go back with <C-o>
          autoload -Uz cd_undo
          zle -N cd_undo
          bindkey '^O' cd_undo

          # Go to parent dir with <C-p>
          autoload -Uz cd_parent
          zle -N cd_parent
          bindkey '^P' cd_parent

          # Fix the home, end and delete keys
          bindkey '^[[H' beginning-of-line
          bindkey '^[[F' end-of-line
          bindkey '^[[3~' delete-char
          bindkey '^[3;5~' delete-char

          bindkey -M viins 'jk' vi-cmd-mode
          bindkey -M vicmd ' ' execute-named-cmd

          # Adapt the __vi_cursor to the mode
          autoload -Uz add-zsh-hook add-zsh-hook-widget

          typeset -Ag __vi_cursor=(
              insert '\e[6 q' # beam
              normal '\e[0 q' # underline
              operator_pending '\e[4 q' # block
          )

          function __restore_cursor() {
              echo -ne "''${__vi_cursor[normal]}"
          }
          add-zsh-hook precmd __restore_cursor

          function zle-line-init() {
              echo -ne "''${__vi_cursor[insert]}"
          }
          zle -N zle-line-init

          function zle-keymap-select {
              case $KEYMAP in
                  viins|main) echo -ne "''${__vi_cursor[insert]}"  ;;
                  viins|main) echo -ne "''${__vi_cursor[operator_pending]}" ;;
                  *)          __restore_cursor ;;
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
          bindkey -a 'cs' change-surround
          bindkey -a 'ds' delete-surround
          bindkey -a 'ys' add-surround
          bindkey -M visual 'S' add-surround
        '';
      };
    }

  ];

}
