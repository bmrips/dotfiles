{ lib, pkgs, ... }:

{
  programs.yazi = lib.mkMerge [

    {
      settings.mgr = {
        sort_by = "natural";
        sort_translit = true;
      };
      keymap = {
        mgr.prepend_keymap = [
          {
            on = "<C-q>";
            run = "close";
            desc = "Close";
          }
          {
            on = "<C-s>";
            run = ''shell "$SHELL" --block --confirm'';
            desc = "Open shell here";
          }
          {
            on = [
              "g"
              "r"
            ];
            run = ''
              shell 'ya pub dds-cd --str "$(git rev-parse --show-toplevel)"' --confirm
            '';
            desc = "Go to root of Git repo";
          }
        ];
        tasks.prepend_keymap = [
          {
            on = "<C-q>";
            run = "close";
            desc = "Close tasks";
          }
        ];
        pick.prepend_keymap = [
          {
            on = "<C-q>";
            run = "close";
            desc = "Close pick";
          }
        ];
        input.prepend_keymap = [
          {
            on = "<C-q>";
            run = "close";
            desc = "Close input";
          }
        ];
      };
    }

    {
      plugins.toggle-pane = pkgs.yaziPlugins.toggle-pane;
      keymap.mgr.prepend_keymap = [
        {
          on = "|";
          run = "plugin toggle-pane min-preview";
          desc = "Toggle preview";
        }
      ];
    }

    {
      plugins.no-status = pkgs.yaziPlugins.no-status;
      initLua = "require('no-status'):setup()";
    }

  ];
}
