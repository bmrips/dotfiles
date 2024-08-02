{
  imports = [ ../default.nix ];

  profiles = {
    adesso.enable = true;
    gui.enable = true;
    macos.enable = true;
    uni-muenster.enable = true;
  };
}
