#!/bin/bash
source "${pwd}/scripts/common.sh"

function package_check() {
    local cmd=$(paru -Q $1)
    if [ -z "${cmd}" ];then
        return 1;
    fi
    return 0;
}

function package_install() {
    local pkg="$1"
    local pkgname="$2"
    if [ -z $pkgname ];then
        pkgname=$pkg
    fi

    local flag=0
    if ! package_check "${pkgname}" ;then
        e_info "try install ${pkg}"
        paru -S ${pkg} --noconfirm
        flag=1
    fi
    if ! package_check "${pkgname}" ;then
        e_err "install ${pkg} get some error. try manual..."
        return 1;
    fi
    e_ok "installed ${pkg} "
}

function package_link() {
    local name="$1"
    local dir1="${pwd}/software/${name}"
    local dir2="${xhome}/.config/${name}"

    if [ ! -d ${dir1} ];then
        e_err "dir1 is not exist, exit"
        return 1
    fi

    if [ -h ${dir2} ];then
        e_ok "linked ${name}"
        return 0
    fi

    if [ -d ${dir2} ];then
        e_info "delete dir: ${dir2}"
        rm -rf ${dir2}
    elif [ -f ${dir2} ];then
        e_info "delete file: ${dir2}"
        rm -f ${dir2}
    fi

    e_info "start link"
    ln -s ${dir1} ${dir2}
    if [ -h ${dir2} ];then
        e_ok "linked ${name}"
        return 0
    else
        e_err "${dir2} link failed, try manual"
        exist 1
    fi
}

function file_copy() {
    cp -f $1 $2
}

function file_link() {
    ln -sf $1 $2
}

function dir_copy() {
    local dir1="$1"
    local dir2="$2"
    if [ ! -d ${dir2} ];then
        mkdir -p ${dir2}
    fi
    cp -r ${dir1} ${dir2}
}