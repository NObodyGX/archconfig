function jpegop --description "Optimize jpeg with jpegoptim in dir"
    switch "$argv"
        case -v --version
            echo "jpegop, version 1.0.2"
            return 0
        case "" -h --help
            echo 'Usage: jpegop [Options] $idir $rank'
            echo 'Options:'
            echo '    -v or --version  print version'
            echo '    -h or --help     print help message'
            echo 'Param:'
            echo "    idir: input dir, it will mv jpeg into old"
            echo "    rank: <OPTION>, optimize level, 0-100, default=75"
            return 0
        case '*'
            echo "start jpegop $argv"
    end

    if test -z "$argv"
        echo "error in param"
        return 2
    end
    set -l jsrc $argv[1]
    set -l jrank $argv[2]

    if test -z "$jrank"
        set jrank '75'
    end

    if not test -d "$jsrc"
        set_color $fish_color_error
        echo -n '[ERROR]'
        set_color normal
        echo 'not a valid dir, exit.'
        return 1
    end

    set -l L_TMP_DIR "$jsrc/old"
    if ! test -d $L_TMP_DIR
        mkdir -p $L_TMP_DIR
    end

    for fff in (ls $jsrc)
        if not test -f "$jsrc/$fff"
            continue
        end
        if not test (path extension $fff) = '.jpg'
            continue
        end
        mv "$jsrc/$fff" "$L_TMP_DIR/$fff"
    end

    for fff in (ls $L_TMP_DIR)
        if not test -f "$L_TMP_DIR/$fff"
            continue
        end
        if not test (path extension $fff) = '.jpg'
            continue
        end
        jpegoptim -m$jrank $L_TMP_DIR/$fff -d $jsrc
        touch "$jsrc/$fff" -r "$L_TMP_DIR/$fff"
    end
end
