function rdate --description "random date for year"
    function __n_print_help
        echo 'Usage: vidop [Options] $year'
        echo 'Options:'
        echo '    -h or --help     print help message'
        echo '    -r or --rank     optimize level, 0-copy, 1-mp5, 2-mp4 default=2'
        echo 'Param:'
        echo "    year: start-year"
        echo "Example:"
        echo "    rdate 2019"
    end

    if test -z "$argv"
        echo "error in param"
        return 2
    end

    set -l l_year $argv[1]

    # 计算该年第一天和最后一天的时间戳
    set start_timestamp (date -d "$l_year-01-01" +%s)
    set end_timestamp (date -d "$l_year-12-31" +%s)

    # 生成随机时间戳
    set random_timestamp (shuf -i $start_timestamp-$end_timestamp -n 1)

    # 将随机时间戳转换为日期
    date -d "@$random_timestamp" +"%Y-%m-%d"
    date -d "@$random_timestamp" +"%Y-%m-%d" | tr -d '\n' | xclip -selection clipboard
end
