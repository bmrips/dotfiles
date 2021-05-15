# Let GTK appliations use the KDE file chooser dialog if available.
if [[ "$XDG_CURRENT_DESKTOP" = "KDE" ]]; then
    export GTK_USE_PORTAL=1
fi
