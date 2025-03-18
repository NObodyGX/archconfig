function vidop --description "transform video by ffmpeg"
    function __n_print_help
        echo 'Usage: vidop [Options] $idir'
        echo 'Options:'
        echo '    -h or --help     print help message'
        echo '    -r or --rank     optimize level, 0-copy, 1-mp5, 2-mp4 default=2'
        echo 'Param:'
        echo "    idir: input dir, it will mv jpeg into zbackup"
        echo "Example:"
        echo "    vidop . --rank=0"
    end

    set -l options (fish_opt --short=h --long=help)
    set options $options (fish_opt --short=r --long=rank --optional-val)
    argparse $options -- $argv

    if ! test -z $_flag_h
        __n_print_help
        return 0
    end
    if test -z "$argv"
        echo "error in param"
        return 2
    end
    set -l l_src (string split0 $argv --no-empty)
    set -l l_rank $_flag_r
    set -l l_old "$l_src/old"

    if test -z "$l_rank"
        set l_rank '2'
    end

    for l_ifile in $l_src
        if not test -f $l_ifile
            continue
        end
        set -l l_bname (path change-extension '' $l_src)
        set -l l_fname (string join '' $l_bname '.mp4')
        echo $l_ifile
        echo $l_fname
        if test $l_ifile = $l_fname
            set l_fname (string join '' $l_fname '.mp4')
        end
        switch "$l_rank"
            case '0'
                ffmpeg -hide_banner -i $l_ifile -movflags +faststart -c copy -map 0 $l_fname
            case '1'
                ffmpeg -hide_banner -i $l_ifile -movflags +faststart -preset slow -crf 18 -c:v libx265 $l_fname
            case '2'
                ffmpeg -hide_banner -i $l_ifile -movflags +faststart -preset slow -crf 20 -c:v libx264 $l_fname
            case '*'
                echo "error param"
        end
        echo "[success]tran $l_ifile ====> $l_bfname"
    end
end
