{ lib, ... }:

{
  programs.ripgrep.arguments = lib.gnuCommandArgs {
    smart-case = true;
    colors = [
      "path:style:intense"
      "line:style:intense"
      "match:style:intense"
      "column:fg:green"
      "column:style:intense"
      "match:style:intense"
    ];
  };
}
