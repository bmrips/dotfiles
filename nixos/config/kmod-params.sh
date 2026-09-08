if [[ $UID != 0 ]]; then
    echo 'Error: must be run as root' >&2
    exit 1
fi

mod="$1"

cd -- "/sys/module/$mod/parameters" || exit

modinfo="$(modinfo --parameters "$mod")"

params="$(fd --exact-depth=1)"
max_param_length="$(wc --max-line-length <<<"$params")"
format="%-''${max_param_length}s  %6s  %s\n"

# shellcheck disable=SC2059
printf "$format" PARAMETER VALUE DESCRIPTION

for param in *; do
    paramInfo="$(rg "^$param:" <<<"$modinfo")"
    # shellcheck disable=SC2059,SC2312
    printf "$format" "$param" "$(<"$param")" "${paramInfo#"$param":}"

done
