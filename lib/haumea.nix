{ lib, inputs, ... }:

let
  haumea = inputs.haumea.lib;
in
haumea
// {
  collectModules =
    path:
    lib.collect builtins.isPath (
      haumea.load {
        src = path;
        loader = haumea.loaders.path;
      }
    );
}
