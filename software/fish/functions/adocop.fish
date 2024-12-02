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

    switch "$argv"
        case -v --version
            echo "adocop, version 1.0.0"
            return 0
        case "" -h --help
            __n_print_help
            return 0
        case '*'
            echo "start extract $argv"
    end
    set -l n_src $argv[1]
    set -l n_dst $argv[2]
    if test -z $n_dst
        set n_dst "."
    end

    asciidoctor -b docbook $n_src.adoc -o /tmp/$n_src.xml
    pandoc -f docbook -t markdown_mmd -o $n_dst/$n_src.md /tmp/$n_src.xml --wrap=none
    rm -f /tmp/$n_src.xml
end
