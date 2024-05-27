{ lib, ... }:

with lib;

let
  colorise = extensions: color:
    listToAttrs
    (map (ext: nameValuePair ".${ext}" (toString color)) extensions);

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
  programs.dircolors.settings = {
    "NORMAL" = "00"; # normal text
    "RESET" = "00"; # reset to "normal" color

    # File type
    "FILE" = "00";
    "DIR" = "94";
    "LINK" = "96";
    "ORPHAN" = "91"; # symlink to nonexistent file
    "MISSING" = "31;07"; # a nonexistent target of a symlink
    "MULTIHARDLINK" = "00"; # regular file with more than one link
    "FIFO" = "93"; # pipe
    "SOCK" = "95";
    "DOOR" = "95";
    "BLK" = "93"; # block device
    "CHR" = "93"; # character device

    # Permissions
    "EXEC" = "92";
    "SETUID" = "31;07";
    "SETGID" = "33;07";
    "CAPABILITY" = "31;07";
    "STICKY_OTHER_WRITABLE" = "34;07";
    "OTHER_WRITABLE" = "36;07";
    "STICKY" = "35;07";
  } // colorise archives "91" // colorise (audio ++ video) "95"
    // colorise documents "33" // colorise versionControl "90";
}
