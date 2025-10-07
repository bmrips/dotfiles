{
  config,
  lib,
  pkgs,
  ...
}:

let
  llvmStdenv = with pkgs; overrideCC stdenv (clang.override { inherit (llvmPackages) bintools; });
  kconfig = lib.kconfig {
    inherit config;
    cpuManufacturer = "intel";
  };

  kernel = pkgs.linuxPackages_latest.kernel.override {
    stdenv = llvmStdenv;
    extraMakeFlags = [
      "KCFLAGS+=-march=meteorlake"
      "KCFLAGS+=-mtune=meteorlake"
      "LLVM=1"
    ];
    ignoreConfigErrors = true;
    structuredExtraConfig = lib.mkMerge (
      lib.flatten [
        { LTO_CLANG_THIN = lib.kernel.yes; }
        kconfig.base
        kconfig.intel-only
      ]
    );
  };

in
{
  # Customize the patch set in use for either adding to a tinyconfig or
  # subtracting from defconfig
  # boot.kernelPatches = with (import ./patches.nix {inherit lib;});
  #   subtract ++ base ++ [ custom g14 ];
  # boot.kernelPatches = with (import ./patches.nix {inherit lib;});
  #   addition ++ base ++ [ custom g14 ];

  boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor kernel);
}
