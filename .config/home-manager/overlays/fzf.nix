final: prev:

let
  lsArgs = final.lib.gnuCommandLine {
    color = true;
    group-directories-first = true;
    human-readable = true;
    l = true;
    literal = true;
    time-style = "+t";
  };

  dirPreview = dir:
    final.lib.escapeShellArg
    "ls ${lsArgs} ${dir} | cut --delimiter=' ' --fields=1,5- | sed 's/ t / /' | tail -n+2";

  subshell = cmd: ''\"\$(${cmd})\"'';

in { lib = prev.lib // { shell = { inherit dirPreview subshell; }; }; }
