{
  programs.readline.variables = {
    editing-mode = "vi";

    # Different cursor shapes for each mode
    show-mode-in-prompt = true;
    vi-cmd-mode-string = "\\1\\e[2 q\\2";
    vi-ins-mode-string = "\\1\\e[6 q\\2";

    # Completion
    colored-completion-prefix = true;
    colored-stats = true; # indicate a file's type by color
    mark-symlinked-directories = true; # append slash to symlinked directories
    menu-complete-display-prefix = true;
    show-all-if-ambiguous = true; # show immediately
  };
}
