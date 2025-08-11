{ lib, ... }:

let
  lsArgs = lib.gnuCommand.line {
    color = true;
    group-directories-first = true;
    human-readable = true;
    l = true;
    literal = true;
    time-style = "+t";
  };

in
{
  dirPreview =
    dir:
    lib.escapeShellArg "ls ${lsArgs} ${dir} | cut --delimiter=' ' --fields=1,5- | sed 's/ t / /' | tail -n+2";

  subshell = cmd: ''\"\$(${cmd})\"'';
}
