{ config, lib, ... }:

lib.mkIf config.programs.merkuro.enable {
  programs.plasma.configFile.kalendarrc = {
    General = {
      enableMaps = true;
      forceCollapsedMainDrawer = true;
      lastOpenedView = "WeekView";
    };
    MonthView = {
      monthGridMode = "BasicMonthGrid";
      showWeekNumbers = true;
    };
    ScheduleView.monthListMode = "BasicMonthList";
    WeekView.hourlyViewMode = "BasicInternalHourlyView";
  };
}
