#!/usr/bin/zsh

alias upgrade="yay -Syyu --noconfirm"
alias ca="conda activate "
alias ysy="yay "
alias yays="yay -Ss "
alias yayS="yay -S "
alias yayr="yay -Rns "
alias yayR="yay -Rnsc "
alias yayq="yay -Q | grep "
alias files="nautilus "
alias kk="du -sh *"
alias gitea_run="gitea web -c /code/code_repos/gitea_env/gitea_home/app.ini"
alias hexo_run="hexo cl && hexo s"
alias hexo_gen="cd /data/shome && hexo gen && cd -"
alias G="git clone --depth=1 "

alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias grep="grep -i --color=auto"
alias mkdir="mkdir -p"
alias ls="ls --color=auto"

function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

function mvimg() {
    local src="$1"
    local dst="/data/zres/images"
    mv "$src" "$dst"
}

function jpegop() {
    local src="$1"
    local rank="$2"
    local extra="$3"
    if [ -z "$rank" ];then
        rank="75"
    fi

    local ori="$1/old"
    if [ ! -d "$ori" ];then
        mkdir -p "$ori"
    fi
    for tf in $(ls $src);do
        if [[ $tf == *.jpg ]];then
            mv -f "${src}/${tf}" "${ori}/${tf}"
        fi
    done
    for tf in $(ls $ori);do
        if [[ $tf == *.jpg ]];then
            jpegoptim -m$rank "${ori}/${tf}" -d "$src" "$extra"
        fi
    done
}

function tvid() {
    local src="$1"
    local mode="$2"
    if [[ "$mode" == "0" ]];then
        ffmpeg -hide_banner -i "$src" -movflags +faststart -c copy -map 0 "${src}_tran0.mp4"
    elif [[ "$mode" == "1" ]];then
        ffmpeg -hide_banner -i "$src" -movflags +faststart -preset slow -crf 18 -c:v libx265 "${src}_tran1.mp4"
    elif [[ "$mode" == "2" ]];then
        ffmpeg -hide_banner -i "$src" -movflags +faststart -preset slow -crf 20 -c:v libx264 "${src}_tran1.mp4"
    else
        echo "error input, use tvid $name $mode"
        echo "mode: 0-copy, 1-lib265, 2-lib264"
    fi
}