#!/bin/bash

pwd=$(cd $(dirname $0);pwd)
sdir="${pwd}/software"
xhome="${HOME}"
xconf="${HOME}/.config"

source "${pwd}/scripts/common.sh"
source "${pwd}/scripts/software.sh"

function sudo_run() {
    sudo -u root -H sh -c "$1"
}

function try_add_text() {
    local content="$1"
    local dst="$2"
    if [ ! -f ${dst} ];then
        echo "" > $dst
    fi
    local cmd=$(cat $dst | grep $content)
    if [ -z $cmd ];then
        echo $content >> $dst
    fi
}

function try_add_text_sudo() {
    local content="$1"
    local dst="$2"
    if [ ! -f ${dst} ];then
        sudo_run "touch $dst"
    fi
    local cmd=$(cat $dst | grep $content)
    if [ -z $cmd ];then
        sudo_run "echo $content >> $dst"
    fi
}

function try_mv() {
    local p="${xhome}"
    if [ -d "${p}/$1" ];then
        mv "${p}/$1" "${p}/$2"
    fi
}

function do_env_check() {
    # check sudo
    e_title "check env"
    e_ok "checked env"
}

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

function do_terminal_wezterm() {
    package_install "wezterm"
    package_install "fish"
    local dst="${xconf}/wezterm"
    if [ ! -d $dst ];then
        package_install "ttf-jetbrains-mono-nerd"
        local url="https://github.com/KevinSilvester/wezterm-config.git"
        git clone --depth=1 $url $dst
    fi
}

function do_terminal_vim() {
    package_install "vim"
    try_mkdir "${xconf}/vim"

    package_link "vim/color" "${sdir}/vim/colors" "${xconf}/vim/colors"
    file_link "${sdir}/vim/vimrc" "${xconf}/vim/vimrc"
}

function do_terminal() {
    e_title "terminal"
    do_terminal_zsh
    do_terminal_foot
    do_terminal_alacritty
    do_terminal_wezterm
    do_terminal_vim
}


function do_input() {
    e_title "input_method"
    package_install "fcitx5"
    package_install "fcitx5-chinese-addons"
    package_install "fcitx5-im" "fcitx5-qt"
    package_install "fcitx5-configtool"
    
    try_add_text_sudo "GTK_IM_MODULE=fcitx5" "/etc/environment"
    try_add_text_sudo "QT_IM_MODULE=fcitx5" "/etc/environment"
    try_add_text_sudo "XMODIFIERS=@im=fcitx5" "/etc/environment"
    try_add_text_sudo "INPUT_METHOD=fcitx5" "/etc/environment"
    try_add_text_sudo "SDL_IM_MODULE=fcitx5" "/etc/environment"
    e_ok "installed fcitx5"
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

function do_text_vscode() {
    package_install "vscodium-bin"
    package_install "vscodium-bin-features"
    package_install "vscodium-bin-marketplace"

    file_copy "${sdir}/vscode/User/settings.json" "${xconf}/VSCodium/User/settings.json"
}

function do_text_pulsar() {
    package_install "pulsar-bin"
    file_copy "${sdir}/pulsar/config.cson" "${xhome}/.pulsar/config.cson"
}

function write_firefox_css() {
    local src="$1"
    try_mkdir "$src/chrome"
    local filename="$src/chrome/userChrome.css"
    if [ ! -f $filename ];then
        cat>"${filename}"<<EOF
/*隐藏分页标签*/
#TabsToolbar { visibility: collapse !important; }
/*动态隐藏书签列*/
:root:not([customizing]) #PersonalToolbar {
max-height: 0 !important;
min-height: 0.1px !important;
opacity: 0;
transition: opacity 0.15s ease-in !important;
}
:root:not([customizing]) :hover > #PersonalToolbar,
:root:not([customizing]) #navigator-toolbox:focus-within #PersonalToolbar {
max-height: 4em !important;
opacity: 1;
}
EOF
    fi

    if [ -f $filename ];then
        e_ok "Checked firefox userCss"
    fi
}

function do_firefox() {
    e_title "firefox"
    package_install "firefox"
    local src="${xhome}/.mozilla/firefox"
    for item in $(ls -a $src); do
        if [ -d "$src/$item" ];then
            if [[ $item == *"default" ]];then
                write_firefox_css $src/$item
            elif [[ $item == *"default-release" ]];then
                write_firefox_css $src/$item
            fi
        fi
    done
}

function do_goldendict() {
    package_install "goldendict-ng-git"
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
    do_text_vscode
    do_text_pulsar
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

    do_goldendict
}

function write_fstab() {
    local diskname="$1"
    local mpoint="$2"

    if [ ! -d $mpoint ];then
        e_info "try create $mpoint"
        sudo_run "mkdir -p $mpoint"
    fi

    local tmpf="/tmp/_tmp2.log"
    local cmd=$(sudo -u root -H sh -c "lsblk -f" > $tmpf)
    local dtype=$(grep "$diskname" $tmpf | awk '{print $2}')
    local duuid=$(grep "$diskname" $tmpf | awk '{print $4}')
    local content="UUID=$duuid   $mpoint   $dtype   defaults,noatime,nodiratime   0   0"
    local dst="/etc/fstab"

    echo " " > $tmpf
    echo "# /dev/$diskname" >> $tmpf
    echo "$content" >> $tmpf

    sudo_run "cat $tmpf >> $dst"
}

function do_disk_mount() {
    # lsblk -f
    # fdisk -l
    local tmpf="/tmp/_tmp1.log"
    local cmd=$(sudo -u root -H sh -c "cat /etc/fstab" > $tmpf)
    if [ -z "$(grep "/data" $tmpf)" ];then
        write_fstab "sda1" "/data"
    else
        e_ok 'mounted /data'
    fi
    if [ -z "$(grep "/code" $tmpf)" ];then
        write_fstab "sdb1" "/code"
    else
        e_ok 'mounted /code'
    fi
}

function main() {
    echo_rainbow "#========== NObodyGX  ==========#"
    echo_rainbow "#========== Arch Conf ==========#"
    echo_rainbow "#==========   START   ==========#"

    do_env_check
    do_terminal
    do_input
    do_files
    do_firefox
    do_dev_software
    do_software
    # todo, add disk check in system
    do_disk_mount
    echo_rainbow "#==========   END   ==========#"
}

main "$@"