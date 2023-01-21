# Let GTK appliations use the KDE file chooser dialog if available.
[[ $XDG_CURRENT_DESKTOP == "KDE" ]] && export GTK_USE_PORTAL=1
