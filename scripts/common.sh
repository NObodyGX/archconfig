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
        rcindex=$(($rcindex +1))
        rcindex=$(($rcindex %$rcnum))
        character=${text:i:1}
        echo -en "\033[${foreground};5;${rccode}m${character}\033[0m"
    done
    echo ""
    return
}
#=============================================

#================= echo color  ===============
function e_title() {
    get_cstyle "b"
    get_ccode "cyan"
    i_echo "********" $* "********"
}
#================= echo normal ===============
function _e_print() {
    get_cstyle ""
    get_ccode "$1"
    i_echo_nowarp "$2"
    get_ccode "$3"
}

function e_info() {
    _e_print "cyan" "[info]" "white"
    i_echo $*
}
function e_warn() {
    _e_print "yellow" "[warn]" "white"
    i_echo $*
}
function e_err() {
    _e_print "red" "[error]" "white"
    i_echo $*
}
function e_ok() {
    _e_print "green" "[ok]" "white"
    i_echo $*
}
#=============================================