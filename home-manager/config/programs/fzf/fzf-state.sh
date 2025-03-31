state_dir=/tmp/fzf
mkdir --parents $state_dir

case $1 in
context)
    if [[ -z $2 ]]; then
        echo "Error: expected a number" >&2
        exit 1
    fi
    start=$(($2 - (FZF_PREVIEW_LINES / 2)))
    echo $((start > 1 ? start : 0))
    exit
    ;;
get-source)
    if [[ -f $state_dir/follow-symlinks ]]; then
        follow="--follow"
    else
        unset follow
    fi
    if [[ -f $state_dir/show-hidden-files ]]; then
        hidden="--hidden"
    else
        unset hidden
    fi
    if [[ -f $state_dir/show-ignored-files ]]; then
        ignored="--no-ignore"
    else
        unset ignored
    fi

    case $2 in
    files)
        eval fd $follow $hidden $ignored --type=file 2>/dev/null
        ;;
    directories)
        eval fd $follow $hidden $ignored --type=directory 2>/dev/null
        ;;
    grep)
        eval rg $follow $hidden $ignored --line-number --no-heading --color=always "\"$3\"" 2>/dev/null
        ;;
    *)
        echo "Error: unknown argument: $2" >&2
        exit 1
        ;;
    esac
    exit
    ;;
toggle)
    if [[ -z $2 ]]; then
        echo "Error: no attribute specified" >&2
        exit 1
    fi

    file="$state_dir/$2"

    if [[ -f $file ]]; then
        rm "$file"
    else
        touch "$file"
    fi

    exit
    ;;
*)
    echo "Error: unknown argument: $1" >&2
    exit 1
    ;;
esac
