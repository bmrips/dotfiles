final: prev:

let
  rev = "b7b9868ddb4cdf762bd4bac66bf3b5efe85b000a";
  sha256 = "0x4sdr7szgl7f7lvrdy2hg1cqr54qrfpdixp1mc35qcf4vpskyp7";
  nurSources = builtins.fetchTarball {
    url = "https://github.com/nix-community/NUR/archive/${rev}.tar.gz";
    inherit sha256;
  };
in { nur = import nurSources { pkgs = final; }; }
