function vidtran --description "transform video by ffmpeg"
    switch "$argv"
        case -v --version
            echo "vidtran, version 1.0.0"
            return 0
        case "" -h --help
            echo 'Usage: vidtran [Options] $ifile $rank'
            echo 'Options:'
            echo '    -v or --version  print version'
            echo '    -h or --help     print help message'
            echo 'Param:'
            echo "    ifile: input file"
            echo "    rank: <OPTION>, 0-copy, 1-hevc, 2-x264"
            return 0
        case '*'
            echo "start vidtran $argv"
    end

    if test -z "$argv"
        echo "error in param"
        return 2
    end
    set -l n_src $argv[1]
    set -l n_rank $argv[2]

    if ! test -f "$n_src"
        echo "error file"
        return 3
    end

    if test -z "$n_rank"
        set n_rank '2'
    end

    set -l n_bname (path change-extension '' $n_src)
    set -l n_bfname (string join '' $n_bname '.mp4')
    switch "$n_rank"
        case '0'
            ffmpeg -hide_banner -i $n_src -movflags +faststart -c copy -map 0 $n_bname-01.mp4
        case '1'
            ffmpeg -hide_banner -i $n_src -movflags +faststart -preset slow -crf 18 -c:v libx265 $n_bfname
        case '2'
            ffmpeg -hide_banner -i $n_src -movflags +faststart -preset slow -crf 20 -c:v libx264 $n_bfname
        case '*'
            echo "error param"
    end
    echo "[success]tran $n_src ====> $n_bfname"
end
