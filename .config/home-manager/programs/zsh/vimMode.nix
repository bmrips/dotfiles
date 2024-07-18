{ config, lib, ... }:

with lib;

{

  options.programs.zsh.enableVimMode = mkEnableOption "Vim mode in Zsh";

  config = mkIf config.programs.zsh.enableVimMode {

    programs.zsh.defaultKeymap = "viins";

    programs.zsh.initExtra = ''
      bindkey -M viins 'jk' vi-cmd-mode

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
