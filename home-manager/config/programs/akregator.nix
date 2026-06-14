{ config, lib, ... }:

lib.mkMerge [

  {
    programs.akregator = {

      feeds = {
        "CS SYD" = {
          comment = "Tom Sydney Kerckhove";
          homepage = "https://cs-syd.eu/";
          type = "RSS";
          url = "https://cs-syd.eu/atom.xml";
        };
        "KDE Blogs" = {
          description = "Recent content on KDE Blogs";
          homepage = "https://blogs.kde.org/";
          type = "RSS";
          url = "https://blogs.kde.org/index.xml";
        };
        "Left Fold" = {
          comment = "Johann Zuber";
          description = "A personal blog about programming topics I enjoy";
          homepage = "https://www.leftfold.tech/";
          type = "RSS";
          url = "https://www.leftfold.tech/feed.xml";
        };
      };

      shortcutSchemes.Custom = {
        "open_kcommand_bar" = "Ctrl+Alt+I";
        "options_configure" = "Ctrl+&lt;";
        "options_configure_keybinding" = "Ctrl+>";
        "options_show_menubar" = "Ctrl+M";
        "file_quit" = "Ctrl+Q";
        "hamburger_menu" = "F10";
        "fullscreen" = "F11";
        "help_whats_this" = "Shift+F1";
        "help_about_app" = "F1";

        "find_in_messages" = "/";
        "focus_to_quickseach" = "S";

        "normal_view" = "Ctrl+1";
        "combined_view" = "Ctrl+2";
        "widescreen_view" = "Ctrl+3";

        "go_previous_article" = "K; ";
        "go_next_article" = "J";
        "go_prev_feed" = "Ctrl+K";
        "go_next_feed" = "Ctrl+J";
        "go_prev_unread_article" = "H";
        "go_next_unread_article" = "L";
        "go_next_unread_feed" = "Ctrl+L";
        "go_prev_unread_feed" = "Ctrl+H";

        "article_open" = "Return";
        "article_open_in_background" = "Ctrl+Return";
        "article_open_external" = "Shift+Return";

        "article_set_status_important" = "I";
        "article_set_status_new" = "N";
        "article_set_status_read" = "R";
        "article_set_status_unread" = "U";

        "feed_add" = "Ctrl+N";
        "feed_fetch_all" = "P";
        "feed_hide_read" = ".";
        "feed_homepage" = "O";
        "feed_mark_all_as_read" = "Ctrl+R";
        "feed_mark_all_feeds_as_read" = "Ctrl+Shift+R";
        "feed_modify" = "F2";

        "feedstree_home" = "Home";
        "feedstree_end" = "End";
        "feedstree_left" = "Left";
        "feedstree_right" = "Right";
        "feedstree_up" = "Up";
        "feedstree_down" = "Down";

        "tab_remove" = "Ctrl+W";
        "select_next_tab" = [
          "Ctrl+."
          "Ctrl+Tab"
        ];
        "select_previous_tab" = [
          "Ctrl+,"
          "Ctrl+Shift+Tab"
        ];
        "activate_tab_01" = "Alt+1";
        "activate_tab_02" = "Alt+2";
        "activate_tab_03" = "Alt+3";
        "activate_tab_04" = "Alt+4";
        "activate_tab_05" = "Alt+5";
        "activate_tab_06" = "Alt+6";
        "activate_tab_07" = "Alt+7";
        "activate_tab_08" = "Alt+8";
        "activate_tab_09" = "Alt+9";

        "viewer_copy" = "Ctrl+C";
        "viewer_print" = "Ctrl+P";

        "zoom_in" = "=; +";
        "zoom_out" = "-";
        "zoom_reset" = "0";
      };

    };
  }

  (lib.mkIf config.programs.akregator.enable {
    programs.plasma.configFile.akregatorrc = {
      Advanced = {
        "Mark Read Delay" = 5;
        "Reset Quick Filter On Node Change" = true;
      };
      Browser = {
        "Close Button On Tabs" = true;
        "New Window In Tab" = true;
      };
      General = {
        "Fetch On Startup" = true;
        "Show Unread In Taskbar" = false;
      };
      MainWindow.MenuBar = "Disabled";
      "Shortcut Schemes"."Current Scheme" = "Custom";
      View = {
        "Hide Read Feeds" = false;
        "ShowMenuBar" = false;
        "View Mode" = 1; # Widescreen view
      };
    };
  })

]
