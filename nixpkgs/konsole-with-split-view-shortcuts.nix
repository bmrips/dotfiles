# Keyboard shortcuts for focus switching are broken in Konsole 26.08
# (https://bugs.kde.org/show_bug.cgi?id=524598). Merge request !1305
# (https://invent.kde.org/utilities/konsole/-/merge_requests/1305) fixes the bug
# and is applied here.

self: super:

{
  kdePackages = super.kdePackages.overrideScope (
    _kSelf: kSuper: {
      konsole = kSuper.konsole.overrideAttrs (old: {
        patches = old.patches or [ ] ++ [
          (self.fetchpatch {
            name = "fix-split-view-shortcuts.patch";
            url = "https://invent.kde.org/utilities/konsole/-/merge_requests/1305.patch";
            hash = "sha256-xW0Dq5AIGx/jdKqSfKq+85vByKSSaLizp9Dhq82HhWs=";
          })
        ];
      });
    }
  );
}
