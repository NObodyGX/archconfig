function chmodxxx --description "remove ex in dir"
    switch "$argv"
        case -v --version
            echo "chmodxxx, version 1.0.2"
            return 0
        case "" -h --help
            echo 'Usage: chmodxxx [Options] $idir $rank'
            echo 'Options:'
            echo '    -v or --version  print version'
            echo '    -h or --help     print help message'
            echo 'Param:'
            echo "    idir: input dir, it will mv jpeg into old"
            return 0
        case '*'
            echo "start chmodxxx $argv"
    end

    set -l n_src $argv[1]

    if not test -d "$n_src"
        set_color $fish_color_error
        echo -n '[ERROR]'
        set_color normal
        echo 'not a valid dir, exit.'
        return 1
    end
    
    for fff in (ls $n_src)
        if not test -f "$n_src/$fff"
            continue
        end
        chmod -x "$n_src/$fff"
    end
end