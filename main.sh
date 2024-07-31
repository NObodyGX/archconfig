#!/bin/bash

pwd=$(cd "$(dirname "$0")" || exit;pwd)
sdir="${pwd}/software"
xhome="$HOME"
xconf="${xhome}/.config"

source "${pwd}/scripts/colorecho.sh"
source "${pwd}/scripts/try.sh"

#============================================#
#                  Terminal                  #
#============================================#

function do_terminal_zsh() {
    print_sub_title "zsh"

    package_install "zsh"
    package_install "fzf"
    package_install "fd"
    package_install "bat"
    package_install "less"

    # check zsh is default
    local cmd="$SHELL"
    if [[ $cmd == *"zsh" ]];then
        print_ok "defaulted zsh"
    else
        print_warn "zsh is not default shell"
        chsh -s "$(which zsh)"
        print_info "you should reboot system and go on..."
        exit 0
    fi

    # zinit install
    try_link_file "${sdir}/zsh/.zshenv" "${xhome}/.zshenv"
    try_link_file "${sdir}/zsh/.zshrc" "${xconf}/zsh/.zshrc"
    if [ ! -f "${xconf}/zsh/zinit/zinit.git/zinit.zsh" ];then
        exec zsh
    else
        print_ok "installed zinit"
    fi
    package_link "zsh/nobodygx" "${sdir}/zsh/nobodygx" "${xconf}/zsh/nobodygx"
    # zinit finish
}

function do_terminal_foot() {
    print_sub_title "foot"

    package_install "ttf-maple-sc-nerd"
    package_install "foot"
    package_install "lsix"

    package_link "foot"
}

function do_terminal_alacritty() {
    print_sub_title "alacritty"

    package_install "ttf-maple-sc-nerd"
    package_install "alacritty"

    package_link "alacritty"
}

function do_terminal_wezterm() {
    print_sub_title "wezterm"

    package_install "wezterm"
    package_install "fish"
    local dst="${xconf}/wezterm"
    if [ ! -d "$dst" ];then
        package_install "ttf-jetbrains-mono-nerd"
        local url="https://github.com/KevinSilvester/wezterm-config.git"
        git clone --depth=1 $url "$dst"
    fi
}

function do_terminal_vim() {
    print_sub_title "vim"

    package_install "vim"
    try_mkdir "${xconf}/vim"

    package_link "vim/color" "${sdir}/vim/colors" "${xconf}/vim/colors"
    try_link_file "${sdir}/vim/vimrc" "${xconf}/vim/vimrc"
}

function do_terminal() {
    print_title "terminal"
    set_pkg_number 5
    do_terminal_zsh
    do_terminal_foot
    do_terminal_alacritty
    do_terminal_wezterm
    do_terminal_vim
}

#============================================#
#                Input Method                #
#============================================#

function do_input_method_fcitx() {
    print_sub_title "fcitx5"

    package_install "fcitx5"
    package_install "fcitx5-chinese-addons"
    package_install "fcitx5-im" "fcitx5-qt"
    package_install "fcitx5-configtool"
}

function do_input_method_env() {
    print_sub_title "write_env"

    try_add_text_sudo "GTK_IM_MODULE=fcitx5" "/etc/environment"
    try_add_text_sudo "QT_IM_MODULE=fcitx5" "/etc/environment"
    try_add_text_sudo "XMODIFIERS=@im=fcitx5" "/etc/environment"
    try_add_text_sudo "INPUT_METHOD=fcitx5" "/etc/environment"
    try_add_text_sudo "SDL_IM_MODULE=fcitx5" "/etc/environment"
}

function do_input_method() {
    print_title "input_method"
    set_pkg_number 2

    do_input_method_fcitx
    do_input_method_env
}

#============================================#
#                 User Files                 #
#============================================#

function do_user_files() {
    print_sub_title "config user-dirs"

    local src="$pwd/system/user-dirs.dirs"
    local dst=${xconf}/user-dirs.dirs
    if ! grep -q "downloads" "$dst" ;then
        try_mv "Documents" "documents"
        try_mv "Downloads" "downloads"
        try_mv "Pictures" "pictures"
        try_mv "Public" "public"
        try_mv "Music" "music"
        try_mv "Videos" "videos"
        
        try_copy_file "$src" "$dst"
    fi
    print_ok "defined user-dirs"
    return 0;
}

function do_user_filemanager() {
    print_sub_title "install_fm"

    package_install "yazi"
    package_install "superfile"
}

function do_files() {
    print_title "file manager"
    set_pkg_number 2

    do_user_filemanager
    do_user_files
}

#============================================#
#               Develop Tools                #
#============================================#

function do_dev_install() {
    print_sub_title "dev"

    package_install "rust"
    package_install "go"
    package_install "nvm"
}

function do_conda() {
    print_sub_title "conda"

    package_install "miniconda3"

    local src="$sdir/conda/.condarc"
    local dst="$xhome/.condarc"
    if [ ! -f "$dst" ];then
        try_copy_file "$sdir" "$dst"
    fi
}

function do_dev_software() {
    print_title "dev"

    do_dev_install
    do_conda
}

#============================================#
#                   Text                     #
#============================================#

function do_text_vscode() {
    print_sub_title "vscode"

    package_install "vscodium-bin"
    package_install "vscodium-bin-features"
    # package_install "vscodium-bin-marketplace"

    try_copy_file "${sdir}/vscode/User/settings.json" "${xconf}/VSCodium/User/settings.json"
}

function do_text_pulsar() {
    print_sub_title "pulsar"

    package_install "pulsar-bin"
    
    try_copy_file "${sdir}/pulsar/config.cson" "${xhome}/.pulsar/config.cson"
}

function do_text_helix() {
    print_sub_title "pulsar"

    package_install "helix"

    local src="/usr/bin/helix"
    local dst="/usr/bin/vi"
    if [ ! -h "$dst" ];then
        print_info "start link $src ==> $dst"
        sudo_run "ln -s $src $dst"
    fi

    if [ -h $dst ];then
        print_ok "link vi"
    else
        print_err "link vi err, try manul"
    fi
}
function do_text_other() {
    print_sub_title "text other"

    package_install "lapce"
    package_install "gedit"
}

function do_text() {
    print_title "text"
    set_pkg_number 4
    
    do_text_vscode
    do_text_pulsar
    do_text_helix
    do_text_other
}

#============================================#
#                   Browser                  #
#============================================#

function write_firefox_css() {
    local tdir="$1"
    local src="$sdir/firefox/userChrome.css"
    local dst="$tdir/chrome/userChrome.css"
    local dstdir
    dstdir=$(dirname "$dst")
    try_mkdir "$dstdir"
    if [ ! -f "$dst" ];then
        try_copy_file "$src" "$dst"
    fi

    if [ -f "$dst" ];then
        print_ok "Checked firefox userCss"
    fi
}

function do_firefox() {
    print_title "firefox"

    package_install "firefox"

    local src="${xhome}/.mozilla/firefox"
    find "$src" -mindepth 1 -maxdepth 1 -type d | while read -r mdir
    do
        if [[ $mdir == *"default" || $mdir == *"default-release" ]];then
            write_firefox_css "$mdir"
        fi
    done
}

function do_goldendict() {
    package_install "goldendict-ng-git"
}

function do_software() {
    print_title "software"
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

#============================================#
#                    Disk                    #
#============================================#

function write_fstab() {
    local diskname="$1"
    local mpoint="$2"

    if [ ! -d "$mpoint" ];then
        print_info "try create $mpoint"
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
    local cmd
    cmd=$(sudo -u root -H sh -c "cat /etc/fstab" > $tmpf)
    if ! grep -q "/data" "$tmpf" ;then
        write_fstab "sda1" "/data"
    else
        print_ok 'mounted /data'
    fi
    if grep -q "/code" "$tmpf";then
        write_fstab "sdb1" "/code"
    else
        print_ok 'mounted /code'
    fi
}



function main() {
    echo_rainbow "#========== NObodyGX  ==========#"
    echo_rainbow "#========== Arch Conf ==========#"
    echo_rainbow "#==========   START   ==========#"
    set_step_total 8

    do_terminal
    do_input_method
    do_files
    do_firefox
    do_dev_software
    do_software
    # todo, add disk check in system
    do_disk_mount
    echo_rainbow "#==========   END   ==========#"
}

main "$@"