{ pkgs, lib, ... }:

let
  llvmStdenv = with pkgs; overrideCC stdenv (clang.override { inherit (llvmPackages) bintools; });

  kernel = pkgs.linuxPackages_latest.kernel.override {
    stdenv = llvmStdenv;
    extraMakeFlags = [
      "KCFLAGS+=-march=meteorlake"
      "KCFLAGS+=-mtune=meteorlake"
      "LLVM=1"
    ];
    ignoreConfigErrors = true;
    structuredExtraConfig.LTO_CLANG_THIN = lib.kernel.yes;
  };

in
{
  boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor kernel);
}
