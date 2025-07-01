state_dir=/tmp/fzf
mkdir --parents $state_dir

shopt -s nullglob
for file in "$state_dir"/*; do
    pre_var=${file#"$state_dir/"}
    eval "${pre_var//-/_}=1"
done

print_icon() {
    if [[ -n ${!1} ]]; then
        echo " ${2:-icon missing} "
    fi
}

print_status() {
    if [[ -n ${!1} ]]; then
        echo "${1//_/ }: yes"
    else
        echo "${1//_/ }: no"
    fi
}

case $1 in
get-label)
    if [[ $BACKGROUND == 'dark' ]]; then
        bg="$(printf '\e[48;2;50;48;47m')"
    else
        bg="$(printf '\e[48;2;242;229;188m')"
    fi
    printf "%s\e[37m%s%s%s%s\e[49m\n" "${2:-label missing}" "$bg" \
        "${follow_symlinks+ f }" \
        "${show_hidden_files+ h }" \
        "${show_ignored_files+ i }"
    ;;
get-source)
    dynamic_args=(
        ${follow_symlinks+--follow}
        ${show_hidden_files+--hidden}
        ${show_ignored_files+--no-ignore}
    )
    case $2 in
    files)
        fd "${dynamic_args[@]}" --exclude='.git' --type=file
        ;;
    directories)
        fd "${dynamic_args[@]}" --exclude='.git' --type=directory
        ;;
    grep)
        rg "${dynamic_args[@]}" --glob='!.git' --line-number --no-heading --color=always "$3"
        ;;
    *)
        echo "Error: unknown argument: $2" >&2
        exit 1
        ;;
    esac
    ;;
get-visible-range)
    if [[ -z $2 ]]; then
        echo "Error: expected a number" >&2
        exit 1
    fi
    start=$(($2 - FZF_PREVIEW_LINES / 2))
    start=$((start > 1 ? start : 0))
    echo "$start:$((start + FZF_PREVIEW_LINES - 1))"
    ;;
status)
    print_status follow_symlinks
    print_status show_hidden_files
    print_status show_ignored_files
    ;;
toggle)
    case $2 in
    follow-symlinks) ;;
    show-hidden-files) ;;
    show-ignored-files) ;;
    *)
        echo "Error: unknown option $2" >&2
        exit 1
        ;;
    esac

    file="$state_dir/$2"

    if [[ -f $file ]]; then
        rm "$file"
    else
        touch "$file"
    fi
    ;;
*)
    echo "Error: unknown argument: $1" >&2
    exit 1
    ;;
esac
