_final: prev:

{
  kdePackages = prev.kdePackages.overrideScope (
    _kFinal: kPrev: {
      konsole = kPrev.konsole.overrideAttrs (prevAttrs: {
        patches = (prevAttrs.patches or [ ]) ++ [
          (prev.fetchpatch {
            name = "enable-full-font-hinting.patch";
            url = "https://invent.kde.org/utilities/konsole/-/commit/a6d366f1fb2e915ad8d0fb9b471a033ef35b7e37.patch";
            hash = "sha256-VBXmQUrHqOXdZzeY2QLe9Hq5u3W+O7t0s1jFzDYQwVs=";
          })
        ];
      });
    }
  );
}
