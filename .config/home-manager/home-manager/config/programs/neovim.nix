{ config, lib, pkgs, ... }:

with lib;

mkMerge [

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
      tree-sitter
      wl-clipboard
    ];
    home.shellAliases = {
      nvim = "TTY=$TTY nvim";
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
    };
    programs.gcc.enable = true; # for nvim-treesitter
  })

]
