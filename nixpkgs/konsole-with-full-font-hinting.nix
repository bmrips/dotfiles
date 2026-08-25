{ inputs, system, ... }:

let
  # Keyboard shortcuts for focus switching are broken in Konsole 26.08
  # (https://bugs.kde.org/show_bug.cgi?id=524598). Hence, stay on Konsole 26.04
  # for the moment.
  konsole-26_04 = inputs.nixpkgs_konsole.legacyPackages.${system}.kdePackages.konsole;
in

final: prev:

{
  kdePackages = prev.kdePackages.overrideScope (
    _kFinal: _kPrev: {
      konsole = konsole-26_04.overrideAttrs (prevAttrs: {
        patches = prevAttrs.patches or [ ] ++ [
          # Fixes https://bugs.kde.org/show_bug.cgi?id=503087 temporarily. A
          # permanent fix was upstreamed in Konsole 26.08.
          (final.fetchpatch {
            name = "enable-full-font-hinting.patch";
            url = "https://invent.kde.org/utilities/konsole/-/commit/a6d366f1fb2e915ad8d0fb9b471a033ef35b7e37.patch";
            hash = "sha256-VBXmQUrHqOXdZzeY2QLe9Hq5u3W+O7t0s1jFzDYQwVs=";
          })
        ];
      });
    }
  );
}
