if [[ $UID != 0 ]]; then
    echo 'Error: must be run as root' >&2
    exit 1
fi

mod="$1"

cd -- "/sys/module/$mod/parameters" || exit

modinfo="$(modinfo --parameters "$mod")"

max_param_length="$(fd --exact-depth=1 | wc --max-line-length)"
format="%-''${max_param_length}s  %6s  %s\n"

# shellcheck disable=SC2059
printf "$format" PARAMETER VALUE DESCRIPTION

for param in *; do
    # shellcheck disable=SC2059
    printf "$format" \
        "$param" \
        "$(cat "$param")" \
        "$(rg "^$param:" <<<"$modinfo" | sed "s/^$param://")"
done
