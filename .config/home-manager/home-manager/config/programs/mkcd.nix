let
  mkcd = ''mkdir --parents "$1" && cd "$1"'';

in
{
  programs.bash = {
    initExtra = ''
        function mkcd() {
      ${mkcd}
        }
    '';
  };
  programs.zsh.siteFunctions.mkcd = mkcd;
}
