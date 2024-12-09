{ lib, ... }:

let
  inherit (lib) ansiEscapeCodes listToAttrs nameValuePair;
  inherit (lib.ansiEscapeCodes) base16 combine reset;

  fg = c: base16.color [ base16.fg base16.bright c ];
  reverse = c:
    combine [ ansiEscapeCodes.reverse (base16.color [ base16.fg c ]) ];

  colorise = extensions: color:
    listToAttrs (map (ext: nameValuePair ".${ext}" color) extensions);

  archives = [
    "7z"
    "ace"
    "alz"
    "arc"
    "arj"
    "bz"
    "bz2"
    "cab"
    "cpio"
    "deb"
    "dwm"
    "dz"
    "ear"
    "esd"
    "gz"
    "jar"
    "lha"
    "lrz"
    "lz"
    "lz4"
    "lzh"
    "lzma"
    "lzo"
    "rar"
    "rpm"
    "rz"
    "sar"
    "swm"
    "t7z"
    "tar"
    "taz"
    "tbz"
    "tbz2"
    "tgz"
    "tlz"
    "txz"
    "tz"
    "tzo"
    "tzst"
    "war"
    "wim"
    "xz"
    "z"
    "Z"
    "zip"
    "zoo"
    "zst"
  ];

  audio = [
    "aac"
    "au"
    "flac"
    "m4a"
    "mid"
    "midi"
    "mka"
    "mp3"
    "mpc"
    "oga"
    "ogg"
    "ogv"
    "ogx"
    "opus"
    "ra"
    "spx"
    "wav"
    "xspf"
  ];

  video = [
    "asf"
    "avi"
    "bmp"
    "cgm"
    "dl"
    "emf"
    "flc"
    "fli"
    "flv"
    "gif"
    "gl"
    "jpeg"
    "jpg"
    "m2v"
    "m4v"
    "mjpeg"
    "mjpg"
    "mkv"
    "mng"
    "mov"
    "mp4"
    "mp4v"
    "mpeg"
    "mpg"
    "nuv"
    "ogm"
    "pbm"
    "pcx"
    "pgm"
    "png"
    "ppm"
    "qt"
    "rm"
    "rmvb"
    "svg"
    "svgz"
    "tga"
    "tif"
    "tiff"
    "vob"
    "webm"
    "wmv"
    "xbm"
    "xcf"
    "xpm"
    "xwd"
    "yuv"
  ];

  documents = [ "md" "markdown" "pdf" ];

  versionControl = [ "gitattributes" "gitignore" "gitmodules" ];

in {
  programs.dircolors.settings = with base16;
    {
      NORMAL = reset; # normal text
      RESET = reset; # reset to "normal" color

      # File type
      FILE = reset;
      DIR = fg blue;
      LINK = fg cyan;
      ORPHAN = fg red; # symlink to nonexistent file
      MISSING = reverse red; # a nonexistent target of a symlink
      MULTIHARDLINK = reset; # regular file with more than one link
      FIFO = fg yellow; # pipe
      SOCK = fg magenta;
      DOOR = fg magenta;
      BLK = fg yellow; # block device
      CHR = fg yellow; # character device

      # Permissions
      EXEC = fg green;
      SETUID = reverse white;
      SETGID = reverse yellow;
      CAPABILITY = reverse red;
      STICKY_OTHER_WRITABLE = reverse blue;
      OTHER_WRITABLE = reverse cyan;
      STICKY = reverse magenta;
    } // colorise archives (fg red) // colorise (audio ++ video) (fg magenta)
    // colorise documents (fg yellow) // colorise versionControl (fg black);
}
