{ config, lib, ... }:

let
  inherit (lib) concatStringsSep mkIf mkMerge;

in
mkMerge [

  {
    programs.kmail.shortcutSchemes.Custom = {

      cancel = "Esc";
      kmail_undo = "Ctrl+Z";

      file_quit = "Ctrl+Q";
      close_current_tab = "Ctrl+W";
      create_new_tab = "Ctrl+T";
      activate_next_tab = "Ctrl+]";
      activate_previous_tab = "Ctrl+[";
      activate_tab_01 = "Alt+1";
      activate_tab_02 = "Alt+2";
      activate_tab_03 = "Alt+3";
      activate_tab_04 = "Alt+4";
      activate_tab_05 = "Alt+5";
      activate_tab_06 = "Alt+6";
      activate_tab_07 = "Alt+7";
      activate_tab_08 = "Alt+8";
      activate_tab_09 = "Alt+9";

      toggle_fixedfont = "X";
      view_source = "V";
      scroll_up_more = "PgUp";
      scroll_down_more = "PgDown";
      zoom_in = [
        "="
        "+"
      ];
      zoom_out = "-";
      zoom_reset = "0";
      mark_all_text = "Ctrl+A";
      kmail_copy = "Ctrl+C";
      toggle_html_display_mode = "Ctrl+H";
      load_external_reference = "Ctrl+Shift+R";
      find_in_messages = "Ctrl+F";

      focus_to_quickseach = "/";
      search_messages = "Ctrl+/";

      expand_thread = ".";
      collapse_thread = ",";
      expand_all_threads = "Ctrl+.";
      collapse_all_threads = "Ctrl+,";
      display_message = [
        "Enter"
        "Return"
      ];
      go_next_message = "J";
      go_next_unread_message = "Shift+J";
      go_prev_message = "K";
      go_prev_unread_message = "Shfit+K";
      go_next_unread_text = "Space";
      select_first_message = [
        "G"
        "Home"
      ];
      select_last_message = [
        "Shift+G"
        "End"
      ];
      akonadi_move_to_trash = [
        "D"
        "Del"
      ];
      delete = [
        "Shift+D"
        "Shift+Del"
      ];
      move_thread_to_trash = [
        "Ctrl+D"
        "Ctrl+Del"
      ];
      delete_thread = [
        "Ctrl+Shift+D"
        "Ctrl+Shift+Del"
      ];

      check_mail = "P";
      akonadi_collection_sync = "F5";
      akonadi_mark_as_unread = "U";
      thread_unread = "Ctrl+U";
      new_message = "N";
      editasnew = "Shift+N";
      post_message = "Ctrl+N";
      reply = "R";
      reply_author = "Shift+A";
      reply_all = "A";
      reply_list = "L";
      noquotereply = "Shift+R";
      message_forward_inline = "F";
      message_forward_redirect = "Shift+F";
      file_open = "Ctrl+O";
      file_print = "Ctrl+P";
      file_print_preview = "Ctrl+Shift+P";
      file_save_as = "Ctrl+S";

      jump_to_folder = "T";
      move_message_to_folder = "M";
      previous_folder = "Ctrl+Tab";
      next_folder = "Ctrl+Shift+Tab";

      help_contents = "F1";
      help_whats_this = "Shift+F1";
      hamburger_menu = "F10";
      kmail_configure_kmail = "Ctrl+Shift+,";
      options_configure_keybinding = "Ctrl+>";
      options_show_menubar = "Ctrl+M";
      open_kcommand_bar = "Ctrl+Alt+I";

    };
  }

  (mkIf config.programs.kmail.enable {

    programs.plasma.configFile = {

      kmail2rc = {
        Composer = {
          attachment-keywords = concatStringsSep "," [
            "angehangen"
            "angehängt"
            "Anhang"
            "attached"
            "attachment"
          ];
          crypto-auto-encrypt = true;
          crypto-warning-unsigned = true;
        };
        FavoriteCollectionView.FavoriteCollectionViewMode = "HiddenMode";
        General = {
          AskEnableUnifiedMailboxes = false;
          ComposerShowMenuBar = false;
          ShowMenuBar = false;
          startSpecificFolderAtStatup = false;
        };
        Geometry.readerWindowMode = "right";
        Reader.AlwaysDecrypt = true;
        Security.CheckPhishingUrl = true;
        "Shortcut Schemes"."Current Scheme" = "Custom";
      };

      akonadi_newmailnotifier_agentrc.General = {
        excludeEmailsFromMe = true;
        replyMail = true;
      };

      akonadi_archivemail_agentrc.General.enabled = false;

    };

    programs.plasma.window-rules = [
      {
        description = "KMail Composer";
        match = {
          title.value = "Composer — KMail";
          window-class.value = "kmail org.kde.kmail2";
        };
        apply.size.value = "660,770";
      }
    ];

  })

]
