final: prev:

let
  addMyPythonPackages = python_final: python_prev: {
    cdhist = python_final.callPackage ../pkgs/cdhist.nix { };
  };

in {
  fzf-tab-completion = final.callPackage ../pkgs/fzf-tab-completion.nix { };
  goto = final.callPackage ../pkgs/goto.nix { };
  pythonPackagesExtensions = prev.pythonPackagesExtensions
    ++ [ addMyPythonPackages ];
}
