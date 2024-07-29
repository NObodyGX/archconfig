#!/bin/bash

pwd=$(cd $(dirname $0);pwd)

source "${pwd}/scripts/common.sh"
source "${pwd}/scripts/software.sh"


function do_terminal_zsh() {
    package_install "zsh"
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