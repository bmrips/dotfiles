{ config, lib, ... }:

with lib;

{

  options.programs.zsh.enableVimMode = mkEnableOption "Vim mode in Zsh";

  config = mkIf config.programs.zsh.enableVimMode {

    programs.zsh.defaultKeymap = "viins";

    programs.zsh.initExtra = ''
      bindkey -M viins 'jk' vi-cmd-mode

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
    '';

  };
}
