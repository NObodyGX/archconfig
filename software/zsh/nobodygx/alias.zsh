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
alias hugo_run="hugo serve --renderToMemory"
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