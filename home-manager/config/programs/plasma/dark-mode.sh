is_enabled() {
    schemes="$(plasma-apply-colorscheme --list-schemes || exit)"
    current_scheme="$(grep current <<<"$schemes" || exit)"
    [[ $current_scheme == *[dD]ark* ]]
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
    # shellcheck disable=SC2310
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
