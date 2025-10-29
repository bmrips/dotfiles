{ lib, pkgs, ... }:

let
  removeStoreEntriesFromPaths =
    lib.concatMapStrings
      (path: /* bash */ ''
        export ${path}="$(${lib.getExe pkgs.gnused} -E 's#/nix/store/[^:]*:?##g' <<<''$${path})"
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
