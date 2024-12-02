#!/bin/bash

pwd=$(
    cd "$(dirname "$0")" || exit
    pwd
)
sdir="${pwd}/software"
xhome="$HOME"
xconf="${xhome}/.config"

source "${pwd}/scripts/colorecho.sh"
source "${pwd}/scripts/try.sh"

#============================================#
#                  Terminal                  #
#============================================#

function do_terminal_fish() {
    print_sub_title "fish"

    try_link_dir "${sdir}/fish" "${xconf}/fish"
}

function do_terminal_zsh() {
    print_sub_title "zsh"

    # check zsh is default
    local cmd="$SHELL"
    if [[ $cmd == *"zsh" ]]; then
        print_ok "defaulted zsh"
    else
        print_warn "zsh is not default shell"
        chsh -s "$(which zsh)"
        print_info "you should reboot system and go on..."
        exit 0
    fi

    # zinit install
    try_link_file "${sdir}/zsh/.zshenv" "${xhome}/.zshenv"
    try_link_file "${sdir}/zsh/.zshrc" "${xhome}/.zshrc"
    if [ ! -f "${xconf}/zsh/zinit/zinit.git/zinit.zsh" ]; then
        exec zsh
    else
        print_ok "installed zinit"
    fi
    package_link "zsh/nobodygx" "${sdir}/zsh/nobodygx" "${xconf}/zsh/nobodygx"
    # zinit finish
}

function do_terminal_foot() {
    print_sub_title "foot"

    package_link "foot"
}

function do_terminal_alacritty() {
    print_sub_title "alacritty"


    package_link "alacritty"
}

function do_terminal_wezterm() {
    print_sub_title "wezterm"

    package_install "wezterm"
    package_install "fish"
    local dst="${xconf}/wezterm"
    if [ ! -d "$dst" ]; then
        package_install "nerd-fonts-sarasa-term"
        try_link_dir "${sdir}/wezterm" "${xconf}/wezterm"
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
    print_title "terminal" 5

    do_terminal_fish
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
    print_sub_title "write input env"

    try_add_text_sudo "GTK_IM_MODULE=fcitx5" "/etc/environment"
    try_add_text_sudo "QT_IM_MODULE=fcitx5" "/etc/environment"
    try_add_text_sudo "XMODIFIERS=@im=fcitx5" "/etc/environment"
    try_add_text_sudo "INPUT_METHOD=fcitx5" "/etc/environment"
    try_add_text_sudo "SDL_IM_MODULE=fcitx5" "/etc/environment"

    print_ok "defined input env"
}

function do_input_method() {
    print_title "input_method" 2

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
    if ! grep -q "downloads" "$dst"; then
        try_mv "Documents" "documents"
        try_mv "Downloads" "downloads"
        try_mv "Pictures" "pictures"
        try_mv "Public" "public"
        try_mv "Music" "music"
        try_mv "Videos" "videos"

        try_copy_file "$src" "$dst"
    fi
    print_ok "defined user-dirs"
    return 0
}

function do_user_filemanager() {
    print_sub_title "install_fm"

    package_install "yazi"
    package_install "superfile"
}

function do_files() {
    print_title "file manager" 2

    do_user_filemanager
    do_user_files
}

#============================================#
#               Develop Tools                #
#============================================#

function do_dev_conda() {
    print_sub_title "conda"

    package_install "miniconda3"

    local src="${sdir}/conda/.condarc"
    local dst="${xhome}/.condarc"
    if [ ! -f "$dst" ]; then
        try_copy_file "$sdir" "$dst"
    fi

    src="${sdir}/conda/pip.conf"
    dst="${xconf}/pip/pip.conf"
    if [ ! -f "$dst" ]; then
        try_copy_file "$sdir" "$dst"
    fi
}

function do_dev_ollama() {
    print_sub_title "ollama"

    # can use ollama[cuda], but gpu is weak
    package_install "ollama"

    local src="${sdir}/ollama/ollama.service"
    local dst="/etc/systemd/system/ollama.service"
    # add user
    if ! id -u "ollama" >/dev/null 2>&1; then
        sudo_run "useradd -r -s /bin/false -m -d /usr/share/ollama ollama"
    fi
    if id -u "ollama" >/dev/null 2>&1; then
        print_ok "installed user(ollama)"
    else
        print_err "add user(ollama)"
    fi
    # add ollama.service
    if [ ! -f "$dst" ]; then
        sudo_run "cp $src $dst"
    fi
    if [ -f "$dst" ]; then
        print_ok "installed ollama.service"
    fi

    sudo_run "systemctl start ollama"
}

function do_dev_gitea() {
    print_sub_title "gitea"

    package_install "gitea"

    local src="${sdir}/gitea/gitea.service"
    local dst="/usr/lib/systemd/system/gitea.service"
    if ! check_by_grep_cat_sudo "$dst" "XGit"; then
        sudo_run "cp -f $src $dst"
    fi

    if check_by_grep_cat_sudo "$dst" "XGit"; then
        print_ok "installed gitea.service"
    else
        print_err "install gitea.service"
    fi

    src="${sdir}/gitea/app.ini"
    dst="/code/code_repos/gitea_env/gitea_home/app.ini"
    if ! check_by_grep_cat "$dst" "xgit"; then
        cp -f "$src" "$dst"
    fi

    if check_by_grep_cat "$dst" "xgit"; then
        print_ok "installed gitea.ini"
    else
        print_err "install gitea.ini"
    fi
}

function do_dev() {
    print_title "dev" 5

    do_dev_conda
    do_dev_ollama
    do_dev_gitea
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

    cd "${xhome}/.pulsar/packages"
    eval "$(tombl -e PKGS=packages ${sdir}/pulsar/packages.toml)"
    for apkg in ${PKGS[@]}
    do
        local pname=$(echo $apkg | awk -F '/' '{print $5}')
        if [[ "$pname"  ]];then
        fi
        # git clone --depth=1 "$apkg"
        echo $pname
    done
    cd -

    try_copy_file "${sdir}/pulsar/config.cson" "${xhome}/.pulsar/config.cson"
}

function do_text_helix() {
    print_sub_title "pulsar"

    package_install "helix"

    local src="${sdir}/helix/config.toml"
    local dst="${xconf}/helix/config.toml"
    try_link_file "$src" "$dst"

    # src="${sdir}/helix/languages.toml"
    # dst="${xconf}/helix/languages.toml"
    # try_link_file "$src" "$dst"

    src="/usr/bin/helix"
    dst="/usr/bin/vi"
    if [ ! -h "$dst" ]; then
        print_info "start link $src ==> $dst"
        sudo_run "ln -s $src $dst"
    fi

    if [ -h $dst ]; then
        print_ok "link vi"
    else
        print_err "link vi err, try manul"
    fi
}


function do_text() {
    print_title "text" 4

    do_text_vscode
    do_text_pulsar
    do_text_helix
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
    if [ ! -f "$dst" ]; then
        try_copy_file "$src" "$dst"
    fi

    if [ -f "$dst" ]; then
        print_ok "Checked firefox userCss"
    fi
}

function do_browser_firefox() {
    print_sub_title "firefox"

    package_install "firefox"

    local src="${xhome}/.mozilla/firefox"
    find "$src" -mindepth 1 -maxdepth 1 -type d | while read -r mdir; do
        if [[ $mdir == *"default" || $mdir == *"default-release" ]]; then
            write_firefox_css "$mdir"
        fi
    done
}


#============================================#
#                    Disk                    #
#============================================#

function write_fstab() {
    local diskname="$1"
    local mpoint="$2"
    local cmd="" dtype="" duuid="" content=""

    if [ ! -d "$mpoint" ]; then
        print_info "try create $mpoint"
        sudo_run "mkdir -p $mpoint"
    fi

    cmd=$(sudo_run "lsblk -f")
    dtype=$(echo "$cmd" | grep "$diskname" | awk '{print $2}')
    duuid=$(echo "$cmd" | grep "$diskname" | awk '{print $4}')
    content="UUID=$duuid   $mpoint   $dtype   defaults,noatime,nodiratime   0   0"

    local dst="/etc/fstab"
    sudo_run "echo '' >> $dst"
    sudo_run "echo \# /dev/$diskname >> $dst"
    sudo_run "echo $content >> $dst"
    sudo_run "echo '' >> $dst"
}

function check_todo_disk() {
    local cmd=""
    cmd=$(sudo_run "lsblk -f")
    if ! echo "$cmd" | grep -q "sda1"; then
        return 1
    fi
    if ! echo "$cmd" | grep -q "sdb1"; then
        return 2
    fi

    local dst="/etc/fstab"
    if check_by_grep_cat_sudo "$dst" "/dev/sda1"; then
        return 3
    fi
    if check_by_grep_cat_sudo "$dst" "/dev/sdb1"; then
        return 4
    fi
    return 0
}

function do_disk_mount() {
    print_sub_title "mount disk"

    if ! check_todo_disk; then
        print_ok 'checked mount'
        return 0
    fi

    local dst="/etc/fstab"
    if ! check_by_grep_cat_sudo "$dst" "/data"; then
        write_fstab "sda1" "/data"
    else
        print_ok 'mounted /data'
    fi

    if ! check_by_grep_cat_sudo "$dst" "/code"; then
        write_fstab "sdb1" "/code"
    else
        print_ok 'mounted /code'
    fi
}

function do_disk() {
    print_title "didk" 1

    do_disk_mount
}

function do_network_networkmanager() {
    print_sub_title "networkmanager"

    package_install "dhcpcd"

    local src="${pwd}/system/networkmanager/NetworkManager.conf"
    local dst="/etc/NetworkManager/NetworkManager.conf"
    if ! check_by_grep_cat_sudo "$dst" "wifi.backend=iwd"; then
        print_info "cp $src ==> $dst"
        sudo_run "cp -f $src $dst"
    else
        print_ok "installed NetworkManager.conf"
        return 0
    fi
    if ! check_by_grep_cat_sudo "$dst" "wifi.backend=iwd"; then
        print_err "install NetworkManager.conf wrong"
    else
        print_ok "installed NetworkManager.conf"
    fi

    # src="${pwd}/system/networkmanager/conf.d/dhcp-client.conf"
    # dst="/etc/NetworkManager/conf.d/dhcp-client.conf"
    # if [ -f $dst ];then
    #     print_info "cp $src ==> $dst"
    #     sudo_run "cp -f $src $dst"
    # fi
}


function do_network() {
    print_title "network" 1

    do_network_networkmanager
}



function main() {

    do_terminal
    do_input_method
    do_files
    do_browser
    do_text
    do_dev
    do_software
    do_disk
    do_network
    echo_rainbow "#==========   END   ==========#"
}

function custom_main() {
    do_text_pulsar
}

#main "$@"
custom_main
