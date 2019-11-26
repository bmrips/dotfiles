# Set the QT_QPA_PLATFORMTHEME to qt5ct if KDE is not active.
if [[ "$XDG_CURRENT_DESKTOP" != "KDE" ]]; then
    export QT_QPA_PLATFORMTHEME="qt5ct"
fi
