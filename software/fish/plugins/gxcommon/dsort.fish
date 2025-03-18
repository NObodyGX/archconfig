function dsort --description "sort dir index"
    function __n_print_help
        echo 'Usage: dsort $idir'
        echo 'Options:'
        echo '    -h or --help     print help message'
        echo '    -i or --index    output dir'
        echo '    -g or --gap      gap number'
    end

    set -l options (fish_opt --short=h --long=help)
    set options $options (fish_opt --short=i --long=index --optional-val)
    set options $options (fish_opt --short=l --long=length --optional-val)
    argparse $options -- $argv
    if ! test -z $_flag_h
        __n_print_help
        return 0
    end

    set -l l_item $argv[1]
    set -l l_index $_flag_i
    set -l l_length $_flag_l

    if ! test -d $l_item
        __n_print_help
        return 2
    end
    if test -z $l_index
        set l_index 0
    end
    if test -z $l_length
       set l_length 2
    end

    set -l index $l_index
    for item in (ls $l_item)
        if test -f $l_item/$item
            continue
        end
        set index (math $index + 1)
        set l_i (string pad -w $l_length --char=0 $index)
        dmv $item $l_i
    end
end
