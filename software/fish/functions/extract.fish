function extract --description "extract archives for any"
    function __n_print_help
        echo 'Usage: extract [Options] $ifile $password $odir'
        echo 'Options:'
        echo '    -v or --version  print version'
        echo '    -h or --help     print help message'
        echo 'Param:'
        echo "    ifile:    input file"
        echo "    password: <OPTION>, default=''"
        echo "    odir:     <OPTION>, output dir, default=."
    end

    switch "$argv"
        case -v --version
            echo "extract, version 1.0.0"
            return 0
        case "" -h --help
            __n_print_help
            return 0
        case '*'
            echo "start extract $argv"
    end
    set -l n_src $argv[1]
    set -l n_pwd $argv[2]
    set -l n_dst $argv[3]
    if test -z $n_dst
        set n_dst "."
    end

    if not test -z $n_pwd
        if test $n_pwd = "1"
            set n_pwd "gmw1024"
        end
    end

    if not test -f $n_src
        echo "not a valid file"
        __n_print_help
        return 1
    end

    switch $n_src
        case '*.7z'
            7z x $n_src -p$n_pwd -o$n_dst
        case '*.gz'
            echo "tar zxf $n_src -C $n_dst"
        case '*.br2'
            echo "tar jxf $n_src -C $n_dst"
        case '*.tar'
            echo "tar xf $n_src -C $n_dst"
        case '*.rar'
            unrar x $n_src -p$n_pwd $n_dst
        case '*.zip'
            unzip $n_src -d $n_dst
        case '*'
            echo 'todo'
    end

end
