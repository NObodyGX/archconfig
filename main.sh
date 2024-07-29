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
        e_ok "zsh is default shell"
    else
        e_warn "zsh is not default shell"
        chsh -s $(which zsh)
        e_info "you should reboot system and go on..."
        exit 0
    fi

    # zinit install
    file_copy "${pwdsw}/zsh/.zshenv" "${xhome}/.zshenv"
    file_copy "${pwdsw}/zsh/.zshrc" "${xhome}/.config/zsh/.zshrc"
    exec zsh
    # zinit finish
}

function do_terminal_foot() {
    package_install "foot"
    package_install "lsix"
    package_install "ttf-maple-sc-nerd"

    package_link "foot"
}

function do_terminal() {
    do_terminal_zsh
    do_terminal_foot
}

function main() {
    echo_rainbow "#========== NObodyGX  ==========#"
    echo_rainbow "#========== Arch Conf ==========#"
    echo_rainbow "#==========   START   ==========#"

    do_terminal
    
    echo_rainbow "#==========   END   ==========#"
}

main "$@"