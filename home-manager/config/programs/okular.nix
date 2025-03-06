{ config, lib, ... }:

{
  programs.okular = {

    general.obeyDrm = false;

    shortcutSchemes.Custom = {
      go_goto_page = "Ctrl+G";
      first_page = [
        "G"
        "Home"
      ];
      last_page = [
        "Shift+G"
        "End"
      ];
      view_scroll_up = "Shift+Up";
      view_scroll_down = "Shift+Down";
      view_scroll_page_up = "Backspace";
      view_scroll_page_down = "Space";
      go_document_back = [
        "Shift+H"
        "Alt+Left"
      ];
      go_document_forward = [
        "Shift+L"
        "Alt+Right"
      ];
      edit_find = [
        "Ctrl+F"
        "/"
      ];
      edit_find_next = "N";
      edit_find_prev = "Shift+N";
      close_find_bar = "Esc";
      bookmark_add = "B";
      properties = "Alt+Return";
      file_save = "Ctrl+S";
      file_save_as = "Ctrl+Shift+S";
      presentation = "Shift+P";
      view_zoom_in = [
        "="
        "Ctrl+="
      ];
      view_zoom_out = [
        "-"
        "Ctrl+-"
      ];
      view_actual_size = "Ctrl+0";
      view_orientation_rotate_cw = "]";
      view_orientation_rotate_ccw = "[";
      view_fit_to_width = "W";
      view_fit_to_page = "P";
      fit_window_to_page = "Ctrl+J";
      view_render_mode_single = "S";
      view_render_mode_facing = "F";
      view_render_mode_facing_center_first = "Shift+F";
      view_render_mode_overview = "O";
      view_continuous = "C";
      color_mode_invert_lightness = "I";
      mouse_drag = "Ctrl+1";
      mouse_zoom = "Ctrl+2";
      mouse_select = "Ctrl+3";
      mouse_textselect = "Ctrl+4";
      mouse_tableselect = "Ctrl+5";
      mouse_magnifier = "Ctrl+6";
      edit_copy = [
        "Ctrl+C"
        "Ctrl+Ins"
      ];
      edit_select_all = "Ctrl+A";
      edit_undo = [
        "U"
        "Ctrl+Z"
      ];
      edit_redo = [
        "R"
        "Ctrl+Shift+Z"
      ];
      annotation_highlighter = "Alt+1";
      annotation_underline = "Alt+2";
      annotation_squiggle = "Alt+3";
      annotation_strike_out = "Alt+4";
      annotation_typewriter = "Alt+5";
      annotation_inline_note = "Alt+6";
      annotation_popup_note = "Alt+7";
      annotation_freehand_line = "Alt+8";
      annotation_arrow = "Alt+9";
      annotation_rectangle = "Alt+0";
      annotation_bookmark = "Ctrl+Shift+B";
      file_print = "Ctrl+P";
      file_print_preview = "Ctrl+Shift+P";
      file_open = "Ctrl+O";
      file_quit = "Ctrl+Q";
      file_close = "Ctrl+W";
      tab-next = [
        "Ctrl+Tab"
        "Ctrl+]"
      ];
      tab-previous = [
        "Ctrl+Shift+Tab"
        "Ctrl+["
      ];
      undo-close-tab = "Ctrl+Shift+T";
      help_contents = "F1";
      help_whats_this = "Shift+F1";
      file_reload = [
        "F5"
        "Refresh"
      ];
      mouse_toggle_annotate = "F6";
      show_leftpanel = "F7";
      hamburger_menu = "F10";
      options_configure = "Ctrl+Shift+,";
      options_configure_keybinding = "Ctrl+>";
      options_show_menubar = "Ctrl+M";
      open_kcommand_bar = "Ctrl+Alt+I";
    };

  };

  programs.plasma.configFile = lib.mkIf config.programs.okular.enable {
    okularrc = {
      MainWindow.MenuBar = "Disabled";
      "Notification Messages".presentationInfo = false;
      "Shortcut Schemes"."Current Scheme" = "Custom";
    };
    okularpartrc = {
      "Dlg Presentation".SlidesShowProgress = false;
      "General".ShowEmbeddedContentMessages = false;
      "Search".FindAsYouType = false;
    };
  };
}
