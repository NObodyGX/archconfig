function dmv --description "add index for dir"
    function __n_print_help
        echo 'Usage: dmv $ifile $index'
        echo 'Param:'
        echo "    ifile: input file/dir"
        echo "    index: index number"
    end
    set -l l_item $argv[1]
    set -l l_index $argv[2]
    if ! test -d $l_item
        __n_print_help
        return 0
    end
    if test -z $l_index
        __n_print_help
        exit
    end
    set -l l_name (string replace -r '^\d+' $l_index $l_item)
    if test -z (string match -r '^\d+-' $l_name)
        set l_name $l_index-$l_item
    end
    if test $l_item = $l_name
        return 0
    end
    mv $l_item $l_name
end
