# Set the QT_QPA_PLATFORMTHEME to qt5ct if KDE is not active.
[[ $XDG_CURRENT_DESKTOP != "KDE" ]] && export QT_QPA_PLATFORMTHEME="qt5ct"
