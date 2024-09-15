{ lib, pkgs, ... }:

let
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "5e65389d1308188e5a990059c06729e2edb18f8a";
    hash = "sha256-XHaQjudV9YSMm4vF7PQrKGJ078oVF1U1Du10zXEJ9I0=";
  };

in {
  programs.yazi = lib.mkMerge [

    {
      settings.manager = {
        sort_by = "natural";
        sort_translit = true;
      };
      keymap = {
        manager.prepend_keymap = [
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
            on = [ "g" "r" ];
            run = ''
              shell 'ya pub dds-cd --str "$(git rev-parse --show-toplevel)"' --confirm
            '';
            desc = "Go to root of Git repo";
          }
        ];
        tasks.prepend_keymap = [{
          on = "<C-q>";
          run = "close";
          desc = "Close tasks";
        }];
        select.prepend_keymap = [{
          on = "<C-q>";
          run = "close";
          desc = "Close select";
        }];
        input.prepend_keymap = [{
          on = "<C-q>";
          run = "close";
          desc = "Close input";
        }];
      };
    }

    {
      plugins.hide-preview = "${yazi-plugins}/hide-preview.yazi";
      keymap.manager.prepend_keymap = [{
        on = "|";
        run = "plugin --sync hide-preview";
        desc = "Toggle preview";
      }];
    }

    {
      plugins.no-status = "${yazi-plugins}/no-status.yazi";
      initLua = "require('no-status'):setup()";
    }

  ];
}
