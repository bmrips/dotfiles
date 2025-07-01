state_dir=/tmp/fzf
mkdir --parents $state_dir

for file in "$state_dir"/*; do
    pre_var=${file#"$state_dir/"}
    eval "${pre_var//-/_}=1"
done

case $1 in
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
