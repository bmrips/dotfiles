{ config, lib, ... }:

{
  options.profiles.uni-muenster.enable = lib.mkEnableOption "the University of Münster profile";

  config = lib.mkIf config.profiles.uni-muenster.enable {

    programs.ssh.matchBlocks.uni-muenster = {
      host = "*.uni-muenster.de";
      user = "git";
    };

  };
}
