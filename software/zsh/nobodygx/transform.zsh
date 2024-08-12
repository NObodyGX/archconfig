#!/bin/bash

valid_fname=""

function do_valid_name() {
    local fname=$(realpath $1)

    if [ ! -f $fname ];then
        valid_fname=$fname
        return 0
    fi

    local fname=$(realpath $1)
    local dname=$(dirname $fname)
    local bname=$(basename $fname)
    local hname=$(echo $bname | cut -d . -f1)
    local ename=$(echo $bname | cut -d . -f2)
    local ftar=""

    for i in 100 .. 10000; do
        ftar="${dname}/${hname}_${i}.${ename}"
        if [ ! -f "$ftar" ];then
            valid_fname="$ftar"
            return 0
        fi
    done
    return 1
}

function do_real_tran_0() {
    local src="$1"
    local tmp="$2"
    local dst="$3"
    cmd="ffmpeg -hide_banner -i $src  -movflags faststart -vcode hevc -preset slow -y $tmp"
    echo $cmd
    _=$(ffmpeg -i $src -vcodec hevc -preset slow -movflags faststart -y $tmp)
    if [ ! -f $tmp ];then
        return 1
    fi
    if  ! do_valid_name "$dst" ;then
        echo "no valid name to transform"
        return 2
    fi
    mv "$tmp" "$valid_fname"

    return 0
}

function gtran() {
    local fname=$(realpath $1)
    local dname=$(dirname $fname)
    local bname=$(basename $fname)
    local hname=$(echo $bname | cut -d . -f1)
    local ename=$(echo $bname | cut -d . -f2)
    local tmp="${dname}/_tmp_00.mp4"
    local dst="${dname}/${hname}.mp4"
    if [[ $ename == "avi" ]];then
        if ! do_real_tran_0 "$fname" "$tmp" "$dst" ;then
            echo "tranform error"
            return 1
        else
            echo "transform success"
        fi
    else
        echo "extersion$extersion is not supported"
    fi
    return 0
}