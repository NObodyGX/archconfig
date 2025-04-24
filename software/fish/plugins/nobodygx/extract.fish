function extract --description "extract archives for any"
    function __n_print_help
        echo 'Usage: extract [Options] $ifiles --password=$password --odir=$odir'
        echo 'Options:'
        echo '    -h or --help     print help message'
        echo '    -p or --password password for tar'
        echo '    -o or --odir     output dir'
        echo 'Param:'
        echo "    ifiles: input files"
        echo "Example:"
        echo "    extract a.rar b.rar c.rar --password=112233 -o /code/tmp"
    end

    set -l options (fish_opt --short=h --long=help)
    set options $options (fish_opt --short=p --long=password --optional-val)
    set options $options (fish_opt --short=o --long=odir --optional-val)
    argparse $options -- $argv

    if ! test -z $_flag_h
        __n_print_help
        return 0
    end

    set -l l_src (string split0 $argv --no-empty)
    set -l l_pwd $_flag_p
    set -l l_dst $_flag_o
    if test -z $l_dst
        set l_dst "."
    end

    if ! test -z $l_pwd
        if test $l_pwd = "1"
            set l_pwd "gmw1024"
        end
    end

    for l_ifile in $l_src
        if ! test -f $l_ifile
            continue
        end
        switch $l_ifile
            case '*.7z'
                7z x $l_ifile -p$l_pwd -o$l_dst
            case '*.gz'
                echo "tar zxf $l_ifile -C $l_dst"
            case '*.br2'
                echo "tar jxf $l_ifile -C $l_dst"
            case '*.tar'
                echo "tar xf $l_ifile -C $l_dst"
            case '*.rar'
                unrar x $l_ifile -p$l_pwd $l_dst
            case '*.zip'
                unzip $l_ifile -d $l_dst
            case '*.epub'
                unzip $l_ifile -d $l_dst
            case '*'
                echo 'todo'
        end
    end
end
