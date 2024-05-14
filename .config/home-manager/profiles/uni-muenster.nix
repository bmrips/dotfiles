{ config, lib, ... }:

with lib;

{
  options.profiles.uni-muenster.enable =
    mkEnableOption "the University of Münster profile";

  config = mkIf config.profiles.uni-muenster.enable {

    programs.ssh.matchBlocks.uni-muenster = {
      host = "*.uni-muenster.de";
      user = "git";
      identityFile = "~/.ssh/uni-muenster";
    };

  };
}
