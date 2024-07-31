#!/bin/bash

ccode="30"
cstyle=""
foreground=38

function get_ccode() {
    local name="$1"
    case "${name}" in 
        "black") ccode=30;;
        "red") ccode=31;;
        "green") ccode=32;;
        "yellow") ccode=33;;
        "blue") ccode=34;;
        "magenta") ccode=35;;
        "cyan") ccode=36;;
        "white") ccode=37;;
        # extend by 256
        "brown") ccode=52;;
        "purple") ccode=93;;
        "orange") ccode=202;;
        "pink") ccode=206;;
        *) ccode=37;;
    esac
}

function get_foreground_ccode() {
    local name="$1"
    case "${name}" in 
        "black") foreground=40;;
        "red") foreground=41;;
        "green") foreground=42;;
        "yellow") foreground=43;;
        "blue") foreground=44;;
        "magenta") foreground=45;;
        "cyan") foreground=46;;
        "white") foreground=47;;
        *) foreground=40;;
    esac
}

function get_cstyle() {
    local name="$1"
    case "${name}" in 
        "") cstyle="";;
        "b") cstyle="1;";;
        "i") cstyle="3;";;
        "st") cstyle="9;";;
        *) cstyle="";;
    esac
}

function i_echo() {
    echo -e "\\033[${cstyle}${ccode}m$*\\033[m"
}

function i_echo_nowarp() {
    echo -en "\\033[${cstyle}${ccode}m$*\\033[m"
}

#================= echo rainbow ==============
rcindex=0
rccolors=( 196 208 226 118 46 48 51 33 21 93 201 198 )
rcnum=${#rccolors[@]}
function echo_rainbow() {
    foreground=38
    text="$1"
    for (( i=0 ; i < ${#text} ; i++ )); do 
        rccode=${rccolors[$rcindex]}
        rcindex=$((rcindex +1))
        rcindex=$((rcindex % rcnum))
        character=${text:i:1}
        echo -en "\033[${foreground};5;${rccode}m${character}\033[0m"
    done
    echo ""
    return
}
#=============================================



#================= index count ===============
step_index=0
step_total=99
pkg_index=0
pkg_total=99

function _print() {
    get_cstyle "$1"
    get_ccode "$2"
    i_echo_nowarp "$3"
    get_ccode "$4"
}

function print_title() {
    step_index=$((step_index+1))
    _print "b" "blue" "" "blue"
    local name="$1"
    i_echo "#======== [$step_index/$step_total] STEP $name ========#"
}

function print_sub_title() {
    pkg_index=$((pkg_index+1))
    _print "b" "cyan" "" "cyan"
    local name="$1"
    i_echo "[$pkg_index/$pkg_total] install $name "
}

function set_pkg_number() {
    pkg_total=$1
    pkg_index=0
}

function print_ok() {
    _print "" "green" "  ✅  " "white"
    i_echo "$*"
}

function print_err() {
    _print "" "red" "  ⛔ " "white"
    i_echo "$*"
}

function print_info() {
    _print "" "white" "  [info] " "white"
    i_echo "$*"
}

function print_warn() {
    _print "" "yellow" "  [warn] " "yellow"
    i_echo "$*"
}
#=============================================