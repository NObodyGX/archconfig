#!/bin/bash

pwd=$(cd $(dirname $0);pwd)
sdir="${pwd}/software"
xhome="${HOME}"
xconf="${HOME}/.config"

source "${pwd}/scripts/common.sh"
source "${pwd}/scripts/software.sh"


function do_terminal_zsh() {
    package_install "zsh"
    package_install "fzf"
    package_install "fd"
    package_install "bat"
    package_install "less"

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
    file_link "${sdir}/zsh/.zshenv" "${xhome}/.zshenv"
    file_link "${sdir}/zsh/.zshrc" "${xconf}/zsh/.zshrc"
    if [ ! -f "${xconf}/zsh/zinit/zinit.git/zinit.zsh" ];then
        exec zsh
    else
        e_ok "installed zinit"
    fi
    package_link "zsh/nobodygx" "${sdir}/zsh/nobodygx" "${xconf}/zsh/nobodygx"

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
    local ff=${xconf}/user-dirs.dirs
    local v=$(cat $ff | grep downloads)
    if [ -z $v ];then
        try_mv "Documents" "documents"
        try_mv "Downloads" "downloads"
        try_mv "Pictures" "pictures"
        try_mv "Public" "public"
        try_mv "Music" "music"
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
    fi
    e_ok "defined user-dirs"
    return 0;
}

function do_user_filemanager() {
    package_install "yazi"
    package_install "superfile"
}

function do_files() {
    e_title "files"
    do_user_files
    do_user_filemanager
}

function do_dev_software() {
    e_title "dev"
    package_install "rust"
    package_install "go"
    package_install "nvm"
    package_install "anaconda"
}


function do_software() {
    e_title "software"
    # video
    package_install "vlc"
    package_install "mpv"
    # netease-cloud
    package_install "qcm"
    package_install "syncthing"
    # picture
    package_install "inkscape"
    package_install "feh"
    package_install "krita"
    package_install "gimp"
    # text
    package_install "pulsar-bin"
    package_install "lapce"
    package_install "helix"
    # dev
    package_install "insomnia"
    # disk
    package_install "filelight"
    # eyes
    # work interval relax
    package_install "workrave"
    # package_install "stretchly-bin"
    # light adjust
    package_install "wluma"
}


function main() {
    echo_rainbow "#========== NObodyGX  ==========#"
    echo_rainbow "#========== Arch Conf ==========#"
    echo_rainbow "#==========   START   ==========#"

    do_terminal
    do_files
    do_dev_software
    do_software
    
    echo_rainbow "#==========   END   ==========#"
}

main "$@"