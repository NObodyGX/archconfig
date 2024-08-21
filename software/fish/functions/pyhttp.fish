function pyhttp -d "Start an HTTP server, taking an optional parameter for the port number"
    switch "$argv"
        case -v --version
            echo "pyhttp, version 1.0.1"
        case -h --help
            echo "Usage: pyhttp $dir, run op"
            echo "Options:"
            echo "       -v or --version  print version"
            echo "       -h or --help     print help message"
        case \*
            if test -n "$argv"
                set -l HTTPPORT $argv
            else
                set -l HTTPPORT 8000
            end
            python -m http.server $HTTPPORT
    end
end