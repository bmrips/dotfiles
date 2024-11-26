lib:

let
  lsArgs = lib.gnuCommandLine {
    color = true;
    group-directories-first = true;
    human-readable = true;
    l = true;
    literal = true;
    time-style = "+t";
  };

in {
  shell = {
    dirPreview = dir:
      lib.escapeShellArg
      "ls ${lsArgs} ${dir} | cut --delimiter=' ' --fields=1,5- | sed 's/ t / /' | tail -n+2";

    subshell = cmd: ''\"\$(${cmd})\"'';
  };
}
