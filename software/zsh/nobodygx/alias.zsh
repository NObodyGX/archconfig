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
alias gitear="gitea web -c /code/code_repos/gitea_env/gitea_home/app.ini"
alias hexor="cd /data/shome && hexo cl && hexo s"
alias hexog="cd /data/shome && hexo gen && cd -"
alias hexocl="cd /data/shome && hexo cl "
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

function pngtran() {
    local src="$1"
    local extra="$2"

    source "${HOME}/.config/zsh/nobodygx/utils/progressbar.sh" || exit 1

    local ori="$1/old"
    if [ ! -d "$ori" ];then
        mkdir -p "$ori"
    fi
    for tf in $(ls $src);do
        if [[ $tf == *.png ]];then
            mv -f "${src}/${tf}" "${ori}/${tf}"
        fi
    done
    end=$(ls $ori/*.png | wc -l)
    ii=0
    for tf in $(ls $ori);do
        if [[ $tf == *.png ]];then
            ii=$(($ii+1))
            local _=$(magick "${ori}/${tf}"  "$src/${tf}.jpg")
            progressbar "Convert png into jpg:" $ii $end
        fi
    done
}
