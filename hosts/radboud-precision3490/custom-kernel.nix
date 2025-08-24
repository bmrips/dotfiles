{
  nixpkgs.overlays = [
    (_final: prev: {
      linuxPackages_latest = prev.linuxPackages_latest.extend (
        _kFinal: kPrev: {
          kernel = kPrev.kernel.override {
            extraMakeFlags = [
              "KCFLAGS+=-march=meteorlake"
              "KCLAGS+=-mtune=meteorlake"
            ];
          };
        }
      );
    })
  ];
}
