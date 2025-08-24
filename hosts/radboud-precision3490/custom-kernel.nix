{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxKernel.kernels.linux_latest.override {
    extraMakeFlags = [
      "KCFLAGS+=-march=meteorlake"
      "KCFLAGS+=-mtune=meteorlake"
    ];
  };
}
