{ config, lib, ... }:

{
  home.shellAliases.lg = lib.mkIf config.programs.lazygit.enable "lazygit";

  programs.lazygit.settings = lib.mkMerge [

    {
      customCommands = [
        {
          description = "Push commit";
          context = "commits";
          key = "P";
          prompts = [
            {
              title = "Which remote shall the commit be pushed to?";
              condition = "{{if .SelectedLocalBranch.UpstreamRemote}}false{{end}}";
              type = "menuFromCommand";
              command = "git remote";
              key = "PushRemote";
            }
          ];
          command = ''
            {{- if .SelectedLocalBranch.UpstreamRemote -}}
            git push --force-with-lease {{.SelectedLocalBranch.UpstreamRemote}} {{.SelectedLocalCommit.Hash}}:{{.SelectedLocalBranch.UpstreamBranch}}
            {{- else if .PushRemote -}}
            git push {{.PushRemote}} {{.SelectedLocalCommit.Hash}}:{{.SelectedLocalBranch.Name}}
            {{- end -}}
          '';
          loadingText = "Pushing commit...";
          output = "log";
        }
      ];
      git.overrideGpg = true;
      gui = {
        authorColors = {
          "Benedikt Rips" = "cyan";
          "Rips, Benedikt" = "cyan";
        };
        nerdFontsVersion = "3";
        skipAmendWarning = true;
        skipDiscardChangeWarning = true;
        skipStashWarning = true;
        skipRewordInEditorWarning = true;
      };
      promptToReturnFromSubprocess = false;
    }

    (lib.mkIf config.programs.delta.enable {
      git.pagers = [
        { pager = "delta --paging=never --width=-1"; }
        { pager = "delta --paging=never --width=-1 --side-by-side"; }
      ];
    })

  ];
}
