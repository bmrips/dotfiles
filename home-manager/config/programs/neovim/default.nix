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
    runtimeInputs = [ pkgs.coreutils ];
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
        sideloadInitLua = true;
        extraPackages = with pkgs; [
          harper
          inotify-tools # Replacement for libuv-watchdirs as recommended by lspconfig
          ltex-ls-plus
        ];
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
        DEEPL_AUTH_KEY = config.lib.sops.pathCat "deepl_api_token";
        NVIM_TREESITTER = treesitter;
        LIBSQLITE = "${pkgs.sqlite.out}/lib/libsqlite3.so"; # To speed up snacks.nvim pickers
      };

      xdg.configFile.nvim.source =
        if cfg.immutableConfig then ./. else config.lib.file.mkOutOfStoreSymlink' ./.;

      # Install blink-fuzzy-lib such that it has not to be built by lazy.nvim
      xdg.dataFile."nvim/lazy/blink.cmp/lib/libblink_cmp_fuzzy.so".source =
        "${pkgs.vimPlugins.blink-cmp.passthru.blink-fuzzy-lib}/lib/libblink_cmp_fuzzy.so";
    })

  ];
}
