{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.neovim;

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
{
  options.programs.neovim.immutableConfig = lib.mkEnableOption "immutable configuration.";

  config = lib.mkMerge [

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

      home.shellAliases = {
        v = "nvim";
        vi = "nvim";
        vim = "nvim";
      };

      programs.gcc.enable = true; # for nvim-treesitter

      sops.secrets.deepl_api_token = { };
      home.sessionVariables.DEEPL_API_TOKEN = "$(cat ${config.sops.secrets.deepl_api_token.path})";

      xdg.configFile.nvim.source =
        if cfg.immutableConfig then ./. else config.lib.file.mkOutOfStoreSymlink' ./.;
    })

  ];
}
