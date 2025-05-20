{
  programs.sioyek.bindings = {
    fit_to_page_height = "p";
    fit_to_page_height_smart = "P";
    fit_to_page_width = "w";
    fit_to_page_width_smart = "W";
    goto_mark = "'";
    goto_toc = "<tab>";
    next_page = "J";
    next_state = [
      "."
      "<M-<right>>"
    ];
    open_last_document = ";";
    prev_state = [
      ","
      "<M-<left>>"
    ];
    previous_page = "K";
    reload = "<C-r>";
    toggle_custom_color = "i";
    toggle_horizontal_scroll_lock = "<C-h>";
    toggle_statusbar = "<f3>";
    zoom_in = "=";
  };

  programs.sioyek.config = {
    background_color = "1 1 1";
    custom_background_color = "0.16 0.16 0.16";
    custom_text_color = "0.9 0.9 0.9";
    dark_mode_background_color = "0 0 0";
    font_size = "15";
    page_separator_color = "0.9 0.9 0.9";
    page_separator_width = "2";
    startup_commands = "toggle_horizontal_scroll_lock;toggle_statusbar";
    status_bar_color = "0.16 0.16 0.16";
    super_fast_search = "1";
  };
}
