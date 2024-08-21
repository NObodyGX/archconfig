function pngtran --description "transfrom png into jpeg in dir"
    switch "$argv"
        case -v --version
            echo "pngtran, version 1.0.2"
            return 0
        case "" -h --help
            echo 'Usage: pngtran [Options] $idir $rank'
            echo 'Options:'
            echo '    -v or --version  print version'
            echo '    -h or --help     print help message'
            echo 'Param:'
            echo "    idir: input dir, it will mv jpeg into old"
            echo "    rank: <OPTION>, optimize level, 0-100, default=75"
            return 0
        case '*'
            echo "start pngtran $argv"
    end
    set -l n_src $argv[1]
    set -l n_old "$n_src/old"

    if not test -d "$n_src"
        set_color $fish_color_error
        echo -n '[ERROR]'
        set_color normal
        echo 'not a valid dir, exit.'
        return 1
    end
    if ! test -d $n_old
        mkdir -p $n_old
    end

    for fff in (ls $n_src)
        if not test -f "$n_src/$fff"
            continue
        end
        if not test (path extension $fff) = '.png'
            continue
        end
        mv "$n_src/$fff" "$n_old/$fff"
    end

    set -l n_count (ls $n_old| grep '.png' | wc -l)
    echo $n_count
    set -l n_cur 1
    for fff in (ls $n_old)
        if not test -f "$n_old/$fff"
            continue
        end
        if not test (path extension $fff) = '.png'
            continue
        end
        set -l n_name (path change-extension '' $fff)
        magick "$n_old/$fff" "$n_src/$n_name.jpg"
        print_progress $n_count $n_cur
        set n_cur (math $n_cur + 1)
    end
end
