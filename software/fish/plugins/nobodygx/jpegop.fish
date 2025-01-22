function jpegop --description "Optimize jpeg with jpegoptim in dir"

    function __n_print_help
        echo 'Usage: jpegop [Options] $idir'
        echo 'Options:'
        echo '    -h or --help     print help message'
        echo '    -r or --rank     optimize level, 0-100, default=90'
        echo 'Param:'
        echo "    idir: input dir, it will mv jpeg into zbackup"
        echo "Example:"
        echo "    jpegop . --rank=80"
    end

    set -l options (fish_opt --short=h --long=help)
    set options $options (fish_opt --short=r --long=rank --optional-val)
    argparse $options -- $argv

    if not test -z $_flag_h
        __n_print_help
        return 0
    end
    if test -z "$argv"
        echo "error in param"
        return 2
    end
    set -l l_src $argv[1]
    set -l l_rank $_flag_r

    if test -z "$l_rank"
        set l_rank '90'
    end

    if not test -d "$l_src"
        set_color $fish_color_error
        echo -n '[ERROR]'
        set_color normal
        echo 'not a valid dir, exit.'
        return 1
    end

    set -l L_TMP_DIR "$l_src/zbackup"
    if ! test -d $L_TMP_DIR
        mkdir -p $L_TMP_DIR
    end

    for ifile in (ls $l_src)
        if not test -f "$l_src/$ifile"
            continue
        end
        if not test (path extension $ifile) = '.jpg'
            continue
        end
        mv "$l_src/$ifile" "$L_TMP_DIR/$ifile"
    end

    for ifile in (ls $L_TMP_DIR)
        if not test -f "$L_TMP_DIR/$ifile"
            continue
        end
        if not test (path extension $ifile) = '.jpg'
            continue
        end
        jpegoptim -m$jrank $L_TMP_DIR/$ifile -d $l_src
        touch "$l_src/$ifile" -r "$L_TMP_DIR/$ifile"
    end
end
