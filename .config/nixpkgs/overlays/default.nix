final: prev:

let
  addMyPythonPackages = python_final: python_prev: {
    cdhist = python_final.callPackage ../pkgs/cdhist.nix { };
  };

in {
  goto = final.callPackage ../pkgs/goto.nix { };
  pythonPackagesExtensions = prev.pythonPackagesExtensions
    ++ [ addMyPythonPackages ];
}
