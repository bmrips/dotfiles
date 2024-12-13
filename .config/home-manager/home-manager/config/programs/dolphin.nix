{ config, lib, ... }:

let
  inherit (lib) mkIf mkMerge;
  user = config.home.username;

in mkMerge [

  {
    programs.dolphin = {

      shortcutSchemes.Custom = {
        edit_undo = "Ctrl+Z";
        edit_cut = "Ctrl+X";
        edit_copy = "Ctrl+C";
        edit_paste = "Ctrl+V";
        toggle_selection_mode = "Space";
        edit_select_all = "Ctrl+A";
        invert_selection = "Ctrl+Shift+A";
        create_dir = "Ctrl+N";
        renamefile = "Ctrl+R";
        duplicate = "Ctrl+D";
        movetotrash = "Del";
        deletefile = "Shift+Del";
        properties = [ "Alt+Return" "Alt+Enter" ];
        go_back = [ "Ctrl+H" "Backspace" ];
        go_forward = "Ctrl+L";
        go_up = "Ctrl+K";
        go_home = "Home Page";
        copy_location = "Ctrl+Shift+L";
        editable_location = "F6";
        replace_location = "Ctrl+G";
        delete_shortcut = "Del";
        add_bookmark = "Ctrl+B";
        split_view_menu = [ "Ctrl+S" "F3" ];
        popout_split_view = "Shift+F3";
        copy_to_inactive_split_view = "Ctrl+Shift+C";
        move_to_inactive_split_view = "Ctrl+Shift+X";
        view_redisplay = [ "F5" "Refresh" ];
        show_filter_bar = [ "Ctrl+I" "/" ];
        edit_find = "Ctrl+F";
        open_preferred_search_tool = "Ctrl+Shift+F";
        file_quit = "Ctrl+Q";
        file_close = "Ctrl+W";
        undo_close_tab = "Ctrl+Shift+T";
        new_tab = "Ctrl+T";
        activate_tab_0 = "Alt+1";
        activate_tab_1 = "Alt+2";
        activate_tab_2 = "Alt+3";
        activate_tab_3 = "Alt+4";
        activate_tab_4 = "Alt+5";
        activate_tab_5 = "Alt+6";
        activate_tab_6 = "Alt+7";
        activate_tab_7 = "Alt+8";
        activate_last_tab = "Alt+9";
        activate_next_tab = [ "Ctrl+]" "Ctrl+Tab" ];
        activate_prev_tab = [ "Ctrl+[" "Ctrl+Shift+Tab" ];
        icons = "Ctrl+1";
        compact = "Ctrl+2";
        details = "Ctrl+3";
        view_zoom_in = [ "Ctrl++" "Ctrl+=" ];
        view_zoom_out = "Ctrl+-";
        view_zoom_reset = "Ctrl+0";
        show_preview = "Ctrl+P";
        show_hidden_files = [ "Ctrl+." "." ];
        help_contents = "F1";
        help_whats_this = "Shift+F1";
        show_terminal_panel = "F4";
        open_terminal = "Shift+F4";
        open_terminal_here = "Alt+Shift+F4";
        focus_terminal_panel = "Ctrl+Shift+F4";
        show_folders_panel = "F7";
        show_places_panel = "F9";
        hamburger_menu = "F10";
        show_information_panel = "F11";
        options_show_menubar = "Ctrl+M";
        options_configure_keybinding = "Ctrl+>";
        options_configure = "Ctrl+Shift+,";
        open_kcommand_bar = "Ctrl+Alt+I";
      };

      viewProperties.global = {
        PreviewsShown = false;
        ViewMode = 1;
      };

    };
  }

  (mkIf config.programs.dolphin.enable {

    # Git ignores Dolphin's directory preferences.
    programs.git.ignores = [ ".directory" ];

    programs.plasma.window-rules = [{
      description = "Dolphin";
      match = {
        title = "Home — Dolphin";
        window-class.value = "dolphin org.kde.dolphin";
      };
      apply.size.value = "764,470";
    }];

    programs.plasma.configFile.dolphinrc = {
      ContextMenu = {
        ShowAddToPlaces = false;
        ShowViewMode = false;
      };
      DetailsMode = {
        PreviewSize = 16;
        SidePadding = 0;
      };
      General = {
        GlobalViewProps = false;
        OpenExternallyCalledFolderInNewTab = false;
        RememberOpenedTabs = false;
        ShowSelectionToggle = false;
        ShowSpaceInfo = false;
        ShowStatusBar = false;
        ShowZoomSlider = false;
        SortingChoice = "CaseInsensitiveSorting";
        UseTabForSwitchingSplitView = true;
      };
      PlacesPanel.IconSize = 16;
      "Shortcut Schemes"."Current Scheme" = "Custom";
    };

    # Set in Dolphin's settings.
    programs.plasma.configFile.kiorc = {
      "Executable scripts".behaviourOnLaunch = "alwaysAsk";
      Confirmations = {
        ConfirmDelete = true;
        ConfirmEmptyTrash = true;
        ConfirmTrash = false;
      };
    };

    programs.plasma.configFile.ktrashrc."/home/${user}/.local/share/Trash" = {
      Days = 14; # delete files in the trash after 14 days
      LimitReachedAction = 0; # no-op when reaching the size limit
      UseTimeLimit = true;
    };

  })

]
