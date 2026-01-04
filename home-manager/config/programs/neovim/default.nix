{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.neovim;

  treesitter = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;

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
  options.programs.neovim.immutableConfig = lib.mkEnableOption "immutable configuration";

  config = lib.mkMerge [

    {
      programs.neovim = {
        defaultEditor = true;
        withNodeJs = true; # for markdown-preview.nvim
        withRuby = false;
        extraPackages = [ pkgs.gnumake ]; # for markdown-preview.nvim
        plugins = [ treesitter ];
      };
    }

    (lib.mkIf config.programs.neovim.enable {

      home.packages = [ nvim-prune-undodir ];

      home.shellAliases = {
        v = "nvim";
        vi = "nvim";
        vim = "nvim";
      };

      sops.secrets.deepl_api_token = { };

      home.sessionVariables = {
        DEEPL_AUTH_KEY = "$(cat ${config.sops.secrets.deepl_api_token.path})";
        NVIM_TREESITTER = "${treesitter}";
      };

      xdg.configFile.nvim.source =
        if cfg.immutableConfig then ./. else config.lib.file.mkOutOfStoreSymlink' ./.;
    })

  ];
}
