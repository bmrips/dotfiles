{
  programs.delta = {
    enableGitIntegration = true;

    options =
      let
        fg = "normal";
        hunk_color = "magenta";
      in
      {
        file-modified-label = "𝚫";
        hunk-header-decoration-style = "${hunk_color} ul";
        hunk-header-line-number-style = "${hunk_color}";
        hunk-header-style = "${hunk_color} line-number";
        minus-style = "${fg} auto";
        minus-emph-style = "${fg} auto";
        navigate = true;
        plus-style = "${fg} auto";
        plus-emph-style = "${fg} auto";
        syntax-theme = "base16";
        width = 80;
        zero-style = "${fg}";
      };
  };
}
