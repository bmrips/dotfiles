let
  mkcd = /* bash */ ''mkdir --parents "$1" && cd "$1"'';

in
{
  programs.bash = {
    initExtra = /* bash */ ''
      function mkcd() {
          ${mkcd}
      }
    '';
  };
  programs.zsh.siteFunctions.mkcd = mkcd;
}
