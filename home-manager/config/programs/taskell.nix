{
  config,
  inputs,
  lib,
  pkgs,
  system,
  ...
}:

let
  # The wrapper resolves names based on the working directory to cloud-synced files.
  taskell-wrapper = pkgs.defaults.writeShellApplication {
    name = "taskell";
    runtimeInputs = [ inputs.nixpkgs_23_05.legacyPackages.${system}.taskell ];
    derivationArgs = {
      allowSubstitutes = false;
      preferLocalBuild = true;
    };
    text = /* bash */ ''
      declare file
      if [[ -r taskell.md && -z $1 ]]; then
        file="./taskell.md"
      elif [[ -f ''${1-} ]]; then
        file="$1"
      else
        name="$(basename "''${1-$PWD}")"
        file="$HOME/Cloud/taskell/$name.md"
      fi
      exec -a "$0" taskell "$file"
    '';
  };
in
{
  programs.git.ignores = lib.mkIf config.programs.taskell.enable [ "taskell.md" ];

  programs.taskell = {
    package = taskell-wrapper;
    bindings = {
      new = "n, a";
      edit = "e";
      clear = "c";
      delete = "d";
      listNew = "N, A";
      listEdit = "E";
      listDelete = "D";
    };
    config = {
      general.filename = "taskell.md";
      layout = {
        padding = 1;
        column_width = 30;
        column_padding = 3;
        description_indicator = "≡";
        statusbar = true;
      };
      markdown = {
        title = "##";
        task = "-";
        summary = "    >";
        due = "    @";
        subtask = "    *";
        localTimes = false;
      };
    };
    template = ''
      ## To Do
      ## Done
    '';
    theme.other = {
      statusBar.fg = "black";
      statusBar.bg = "brightBlack";
      subtaskCurrent.fg = "magenta";
      subtaskIncomplete.fg = "default";
      subtaskComplete.fg = "blue";
    };
  };
}
