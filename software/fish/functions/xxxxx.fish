function xxxxx --description "transform video by ffmpeg"
    function __n_print_help
        echo 'Usage: extract [Options] $ifile $password $odir'
        echo 'Options:'
        echo '    -v or --version  print version'
        echo '    -h or --help     print help message'
        echo '    -p or --password password for tar'
        echo '    -o or --odir     output dir'
        echo 'Param:'
        echo "    ifiles:    input file"
        echo "Example:"
        echo "    extract a.rar b.rar c.rar --password=112233 -o /code/tmp"
    end

    set -l options (fish_opt --short=h --long=help)
    set options $options (fish_opt --short=p --long=password --optional-val)
    set options $options (fish_opt --short=o --long=odir --optional-val)
    argparse $options -- $argv

    if not test -z $_flag_h
        __n_print_help
        exit
    end

    set -l n_src (string split0 $argv --no-empty)
    set -l n_pwd $_flag_p
    set -l n_dst $_flag_o
    if test -z $n_dst
        set n_dst "."
    end

    if not test -z $n_pwd
        if test $n_pwd = "1"
            set n_pwd "gmw1024"
        end
    end
    for ll_src in $n_src
        echo $ll_src
    end

end
