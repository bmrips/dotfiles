{ config, lib, ... }:

{
  programs.less.options = {
    color = [
      "Ekc" # information: cyan
      "HkK" # header: gray
      "Mkb" # marks: blue
      "NK-" # line numbers: gray
      "Pkw" # prompt: gray
      "Sky" # search: yellow
      "1kc" # submatches: alternate cyan and magenta
      "2km"
      "3kc"
      "4km"
      "5kc"
    ];
    ignore-case = true; # actually smart-case
    incsearch = true;
    jump-target = 3;
    LONG-PROMPT = true;
    RAW-CONTROL-CHARS = true;
    quiet = true;
    quit-if-one-screen = true;
    save-marks = true;
    use-color = true;
    wheel-lines = 3;
  };

  programs.less.config = ''
    #command
    \b undo-hilite
    < left-scroll
    > right-scroll
    0 no-scroll
    $ end-scroll
  '';

  home.sessionVariables = lib.mkIf config.programs.less.enable {
    MANPAGER = "less --header=1";
  };
}
