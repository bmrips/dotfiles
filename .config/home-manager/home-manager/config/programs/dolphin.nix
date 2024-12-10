{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  user = config.home.username;

in {

  options.programs.dolphin.enable = mkEnableOption "Dolphin.";

  config = mkIf config.programs.dolphin.enable {

    # Git ignores Dolphin's directory preferences.
    programs.git.ignores = [ ".directory" ];

    programs.plasma.window-rules = [{
      description = "Dolphin";
      match.window-class.value = "dolphin org.kde.dolphin";
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
    };

    programs.plasma.dataFile."dolphin/view_properties/global/.directory".Dolphin =
      {
        "PreviewsShown" = false;
        "ViewMode" = 1;
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

  };

}
