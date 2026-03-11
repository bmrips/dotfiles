{ lib, prev, ... }:

prev.types
// {
  pathWithDeps = lib.types.submodule {
    options = {
      path = lib.mkOption {
        description = "The file to be merged.";
        type = lib.types.path;
      };
      dependsOn = lib.mkOption {
        description = "Systemd units that provide the file.";
        default = [ ];
        type = with lib.types; listOf str;
      };
    };
  };
}
