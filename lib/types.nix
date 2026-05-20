{ lib, prev, ... }:

prev.types
// {
  mergeablePath = with lib.types; either path pathWithDeps;
  pathWithDeps = lib.types.submodule {
    options = {
      path = lib.mkOption {
        description = "The file to be merged.";
        type = lib.types.path;
      };
      dependsOn = lib.mkOption {
        description = "Systemd units that provide the file.";
        default = [ ];
        type = with lib.types; listOf nonEmptyStr;
      };
    };
  };
}
