function pngop --description "transfrom png into jpeg in dir"
    function __n_print_help
        echo 'Usage: pngop [Options] $idir'
        echo 'Options:'
        echo '    -h or --help     print help message'
        echo '    -r or --rank     optimize level, 0-100, default=90'
        echo 'Param:'
        echo "    idir: input dir, it will mv jpeg into zbackup"
        echo "Example:"
        echo "    pngop . --rank=80"
    end

    set -l options (fish_opt --short=h --long=help)
    set options $options (fish_opt --short=r --long=rank --optional-val)
    argparse $options -- $argv

    if not test -z $_flag_h
        __n_print_help
        return 0
    end
    set -l l_src $argv[1]
    set -l l_rank $_flag_r
    set -l l_old "$l_src/zbackup"

    if not test -d "$l_src"
        set_color $fish_color_error
        echo -n '[ERROR]'
        set_color normal
        echo 'not a valid dir, exit.'
        return 1
    end
    if ! test -d $l_old
        mkdir -p $l_old
    end

    for ifile in (ls $l_src)
        if not test -f "$l_src/$ifile"
            continue
        end
        if not test (path extension $ifile) = '.png'
            continue
        end
        mv "$l_src/$ifile" "$l_old/$ifile"
    end

    set -l l_count (ls $l_old| grep '.png' | wc -l)
    set -l l_cur 1
    for ifile in (ls $l_old)
        if not test -f "$l_old/$ifile"
            continue
        end
        if not test (path extension $ifile) = '.png'
            continue
        end
        set -l l_nname (path change-extension '' $ifile)
        magick "$l_old/$ifile" "$l_src/$l_nname.jpg"
        touch "$l_src/$l_nname.jpg" -r "$l_old/$ifile"
        print_progress $l_count $l_cur
        set l_cur (math $l_cur + 1)
    end
end
