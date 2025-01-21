function adocop --description "transform asciidoc into markdown"
    function __n_print_help
        echo 'Usage: adocop [Options] $ifile'
        echo 'Options:'
        echo '    -v or --version  print version'
        echo '    -h or --help     print help message'
        echo 'Param:'
        echo "    ifile:    input file"
        echo "    odir:     <OPTION>, output dir, default=."
    end

    set -l options (fish_opt --short=h --long=help)
    set options $options (fish_opt --short=o --long=odir --optional-val)
    argparse $options -- $argv

    set -l l_src $argv[1]
    if string match -aq "*.adoc" $l_src
        set l_src (string sub --end=-5 $argv[1])
    end
    set -l l_dst $_flag_o
    if test -z $l_dst
        set l_dst "."
    end

    asciidoctor -b docbook $l_src.adoc -o /tmp/$l_src.xml
    pandoc -f docbook -t markdown_mmd -o $l_dst/$l_src.md /tmp/$l_src.xml --wrap=none
    python3 ~/.config/fish/nobodygx/adoc_clean.py $l_dst/$l_src.md
    rm -f /tmp/$l_src.xml
end
