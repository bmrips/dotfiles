{ lib, inputs, ... }:

let
  haumea = inputs.haumea.lib;
in
haumea
// {
  collectModules =
    path: args:
    lib.collect builtins.isPath (
      haumea.load {
        src = path;
        inputs = args;
        loader = haumea.loaders.path;
      }
    );
}
