#!/bin/bash

pwd=$(cd $(dirname $0);pwd)
pwdsw="${pwd}/software"
xhome="${HOME}"

source "${pwd}/scripts/common.sh"
source "${pwd}/scripts/software.sh"


function do_terminal_zsh() {
    package_install "zsh"
    package_install "fzf"
    package_install "fd"
    package_install "bat"

    # check zsh is default
    local cmd=$(echo $SHELL)
    if [[ $cmd == *"zsh" ]];then
        e_ok "defaulted zsh"
    else
        e_warn "zsh is not default shell"
        chsh -s $(which zsh)
        e_info "you should reboot system and go on..."
        exit 0
    fi

    # zinit install
    if [ ! -f "${xhome}/.config/zsh/zinit/zinit.git/zinit.zsh" ];then
        file_copy "${pwdsw}/zsh/.zshenv" "${xhome}/.zshenv"
        file_copy "${pwdsw}/zsh/.zshrc" "${xhome}/.config/zsh/.zshrc"
        exec zsh
    else
        e_ok "installed zinit"
    fi
    # zinit finish
}

function do_terminal_foot() {
    package_install "ttf-maple-sc-nerd"
    package_install "foot"
    package_install "lsix"

    package_link "foot"
}

function do_terminal_alacritty() {
    package_install "ttf-maple-sc-nerd"
    package_install "alacritty"

    package_link "alacritty"
}

function do_terminal() {
    e_title "terminal"
    do_terminal_zsh
    do_terminal_foot
    do_terminal_alacritty
}

function try_mv() {
    local p="${xhome}"
    if [ -d "${p}/$1" ];then
        mv "${p}/$1" "${p}/$2"
    fi
}

function do_user_files() {
    local ff=${xhome}/.config/user-dirs.dirs
    local v=$(cat $ff | grep downloads)
    if [ -z $v ];then
        try_mv "Documents" "documents"
        try_mv "Downloads" "downloads"
        try_mv "Pictures" "pictures"
        try_mv "Public" "public"
        try_mv "Videos" "videos"

        echo "" > $ff
        echo "XDG_DESKTOP_DIR=\"\$HOME/Desktop\"" >> $ff
        echo "XDG_DOWNLOAD_DIR=\"\$HOME/downloads\"" >> $ff
        echo "XDG_TEMPLATES_DIR=\"\$HOME/Templates\"" >> $ff
        echo "XDG_PUBLICSHARE_DIR=\"\$HOME/public\"" >> $ff
        echo "XDG_DOCUMENTS_DIR=\"\$HOME/documents\"" >> $ff
        echo "XDG_MUSIC_DIR=\"\$HOME/music\"" >> $ff
        echo "XDG_PICTURES_DIR=\"\$HOME/pictures\"" >> $ff
        echo "XDG_VIDEOS_DIR=\"\$HOME/videos\"" >> $ff
    else
        e_ok "defined user-dirs"
        return 0;
    fi
}

function do_user_media() {
    # video
    package_install "vlc"
    package_install "mpv"
    # netease-cloud
    package_install "qcm"
    package_install "syncthing"

}

function do_files() {
    e_title "files"
    do_user_files
    do_user_media
}

function main() {
    echo_rainbow "#========== NObodyGX  ==========#"
    echo_rainbow "#========== Arch Conf ==========#"
    echo_rainbow "#==========   START   ==========#"

    do_terminal
    do_files
    
    echo_rainbow "#==========   END   ==========#"
}

main "$@"