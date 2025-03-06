{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;

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

in
lib.mkMerge [

  {
    programs.neovim = {
      defaultEditor = true;
      withRuby = false;
    };
  }

  (lib.mkIf config.programs.neovim.enable {
    home.packages = with pkgs; [
      gnumake # for markdown-preview.nvim
      nodejs # for markdown-preview.nvim
      nvim-prune-undodir
      tree-sitter
      wl-clipboard
    ];
    xdg.configFile.nvim.source = mkOutOfStoreSymlink "${config.xdg.configHome}/home-manager/home-manager/config/programs/neovim";
    home.shellAliases = {
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
    };
    programs.gcc.enable = true; # for nvim-treesitter
  })

]
