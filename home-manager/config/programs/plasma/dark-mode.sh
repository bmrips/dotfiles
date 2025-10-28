is_enabled() {
    [[ $(plasma-apply-colorscheme --list-schemes | grep current) == *[dD]ark* ]]
}

disable() {
    plasma-apply-lookandfeel --apply org.kde.breezetwilight.desktop &
    plasma-apply-wallpaperimage "$wallpaper/contents/images/5120x2880.png" &
}

enable() {
    plasma-apply-lookandfeel --apply org.kde.breezedark.desktop &
    plasma-apply-wallpaperimage "$wallpaper/contents/images_dark/5120x2880.png" &
}

toggle() {
    if is_enabled; then
        disable
    else
        enable
    fi
}

case $1 in
isEnabled) is_enabled ;;
disable) disable ;;
enable) enable ;;
toggle) toggle ;;
*) echo "Error: unknown command" >&2 ;;
esac
