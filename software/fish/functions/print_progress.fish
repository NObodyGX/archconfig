set -g progress_version 0.1.0

function __progress_build_info -a total current spintext -d "Build string showing completion info"
    set -l char_diff (math (string length $total) - (string length $current))

    set -l padding
    if test $char_diff -gt 0
        set padding (string repeat -n $char_diff " ")" "
    else
        set padding " "
    end
    printf '\r%s%s%d/%d ' $spintext $padding $current $total
end

function print_progress -a total current -d "Print one state of progress bar"

    set -l done_ratio (math $current / $total)
    set -l modindex (math (math $current % 29) + 1)
    set l_indifer "⠁" "⠁" "⠉" "⠙" "⠚" "⠒" "⠂" "⠂" "⠒" "⠲" "⠴" "⠤" "⠄" "⠄" "⠤" "⠠" "⠠" "⠤" "⠦" "⠖" "⠒" "⠐" "⠐" "⠒" "⠓" "⠋" "⠉" "⠈" "⠈"
    set spintext $l_indifer[$modindex]
    if test $current -eq $total
        set spintext $l_indifer[10]
    end
    set -l info_str (__progress_build_info $total $current $spintext)

    set -l width (math (tput cols) - (string length $info_str))
    set -l n_done (math "floor("$done_ratio" * "$width")")

    echo -ne $info_str
    if test $n_done -eq 0
        echo -ne (string repeat -n $n_done "#")
    else
        echo -ne (string repeat -n (math $n_done -1) "#")
        echo -ne ">"
    end
    echo -ne (string repeat -n (math $width - $n_done) "-")
end
