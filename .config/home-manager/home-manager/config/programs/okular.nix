{ config, lib, ... }:

{
  programs.okular.general.obeyDrm = false;

  programs.plasma.configFile = lib.mkIf config.programs.okular.enable {
    okularrc."Notification Messages".presentationInfo = false;
    okularpartrc = {
      "Dlg Presentation".SlidesShowProgress = false;
      "General".ShowEmbeddedContentMessages = false;
      "Search".FindAsYouType = false;
    };
  };
}
