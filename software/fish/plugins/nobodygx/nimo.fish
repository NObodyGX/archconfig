function nimo --description "monite picture in dirs"
    switch "$argv"
        case -v --version
            echo "nimo, version 1.0.1"
            return 0
        case "" -h --help
            echo 'Usage: nimo [Options] $idir'
            echo 'Options:'
            echo '    -v or --version  print version'
            echo '    -h or --help     print help message'
            echo 'Param:'
            echo "    idir: input dir"
            echo "    height: pic height, default=30"
            return 0
        case '*'
            echo "start jpegop $argv"
    end

    if test -z "$argv"
        echo "error in param"
        return 2
    end
    set -l nsrc $argv[1]
    set -l nwid $argv[2]

    if test -z "$nwid"
        set nwid '30'
    end

    if not test -d "$nsrc"
        set_color $fish_color_error
        echo -n '[ERROR]'
        set_color normal
        echo 'not a valid dir, exit.'
        return 1
    end

    set -l L_TMP_FLAG '0'
    for fff in (ls $nsrc)
        if test (path extension $fff) = '.jpg'
            set L_TMP_FLAG '1'
            break
        end
    end

    switch "$L_TMP_FLAG"
        case '0'
            return 0
        case '*'
            echo "start nimo"
    end

    set -l L_TMP_DIR "$nsrc/drop"
    set -l L_OTH_DIR "$nsrc/todo"
    set -l L_SUC_DIR "$nsrc/succ"
    if ! test -d $L_TMP_DIR
        mkdir -p $L_TMP_DIR
    end
    if ! test -d $L_OTH_DIR
        mkdir -p $L_OTH_DIR
    end
    if ! test -d $L_SUC_DIR
        mkdir -p $L_SUC_DIR
    end

    for fff in (ls $nsrc)
        if not test -f "$nsrc/$fff"
            continue
        end
        if not test (path extension $fff) = '.jpg'
            mv "$nsrc/$fff" "$L_OTH_DIR/$fff"
        end
        while true
            viu "$nsrc/$fff" -h $nwid
            echo "keep it? 1-keep, 2-delete, 3-skip, e-lrot, r-rrot q-exit"
            set -l l_cba (read -n 1)
            switch "$l_cba"
                case '1'
                    mv "$nsrc/$fff" "$L_SUC_DIR/$fff"
                    break
                case '2'
                    mv "$nsrc/$fff" "$L_TMP_DIR/$fff"
                    break
                case 'e'
                    magick convert -rotate -90 "$nsrc/$fff" "$nsrc/$fff"
                case 'E'
                    magick convert -rotate -90 "$nsrc/$fff" "$nsrc/$fff"
                case 'r'
                    magick convert -rotate 90 "$nsrc/$fff" "$nsrc/$fff"
                case 'R'
                    magick convert -rotate 90 "$nsrc/$fff" "$nsrc/$fff"
                case 'q'
                    echo 'exit'
                    clear
                    return 0
                case 'Q'
                    echo 'exit'
                    clear
                    return 0
                case '*'
                    echo "error input, skip"
                    break
            end
            clear
        end
        clear
    end
end
