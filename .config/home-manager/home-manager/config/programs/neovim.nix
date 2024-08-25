{ config, lib, pkgs, ... }:

with lib;

let
  nvim-prune-undodir = pkgs.writeShellApplication {
    name = "nvim-prune-undodir";
    runtimeInputs = with pkgs; [ coreutils ];
    text = ''
      IFS=$'\n'
      for file in ${config.xdg.stateHome}/nvim/undo/*; do
        name="$(basename "$file")"
        if [[ ! -f ''${name//\%//} ]]; then
          rm "$file"
        fi
      done
    '';
  };

in mkMerge [

  {
    programs.neovim = {
      defaultEditor = true;
      withRuby = false;
    };
  }

  (mkIf config.programs.neovim.enable {
    home.packages = with pkgs; [
      gnumake # for markdown-preview.nvim
      nodejs # for markdown-preview.nvim
      nvim-prune-undodir
      tree-sitter
      wl-clipboard
    ];
    home.shellAliases = {
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
    };
    programs.gcc.enable = true; # for nvim-treesitter
  })

]
