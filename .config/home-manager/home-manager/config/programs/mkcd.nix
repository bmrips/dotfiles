let mkcd = ''mkdir --parents "$1" && cd "$1"'';

in {
  config = {
    programs.bash = {
      initExtra = ''
        function mkcd() {
          ${mkcd}
        }
      '';
    };
    programs.zsh = {
      siteFunctions.mkcd = mkcd;
      initExtra = "autoload -Uz mkcd";
    };
  };
}
