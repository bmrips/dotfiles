{
  programs.okular.general.obeyDrm = false;

  programs.plasma.configFile = {
    okularrc."Notification Messages".presentationInfo = false;
    okularpartrc = {
      "Dlg Presentation".SlidesShowProgress = false;
      "General".ShowEmbeddedContentMessages = false;
      "Search".FindAsYouType = false;
    };
  };
}
