is_enabled() {
    [[ $(plasma-apply-colorscheme --list-schemes | grep current) == *[dD]ark* ]]
}

disable() {
    plasma-apply-lookandfeel --apply org.kde.breezetwilight.desktop
}

enable() {
    plasma-apply-lookandfeel --apply org.kde.breezedark.desktop
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
