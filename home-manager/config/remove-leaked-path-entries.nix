{ lib, pkgs, ... }:

let
  sed = "${pkgs.gnused}/bin/sed";
  removeStoreEntriesFromPaths =
    lib.concatMapStrings
      (path: ''
        export ${path}="$(${sed} -E 's#/nix/store/[^:]*:?##g' <<<''$${path})"
      '')
      [
        "XDG_CONFIG_DIRS"
        "XDG_DATA_DIRS"
      ];

in
{
  programs.bash.initExtra = removeStoreEntriesFromPaths;
  programs.zsh.initContent = removeStoreEntriesFromPaths;
}
