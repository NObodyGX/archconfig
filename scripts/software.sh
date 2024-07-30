#!/bin/bash

function package_check() {
    local cmd=$(yay -Q $1)
    if [ -z "${cmd}" ];then
        return 1;
    fi
    return 0;
}

function package_install() {
    local pkg="$1"
    local pname="$2"
    if [ -z $pname ];then
        pname=$pkg
    fi

    local flag=0
    if ! package_check "${pname}" ;then
        e_info "try install ${pkg}"
        yay -S ${pkg} --noconfirm
        flag=1
    fi
    if ! package_check "${pname}" ;then
        e_err "install ${pkg} get some error. try manual..."
        return 1;
    fi
    e_ok "installed ${pkg} "
}

function do_link() {
    local src="$1"
    local dst="$2"

    if [ -h ${dst} ];then
        e_ok "linked ${dst}"
        return 0
    fi

    if [ -d ${dst} ];then
        e_info "delete dir: ${dst}"
        rm -rf ${dst}
    elif [ -f ${dst} ];then
        e_info "delete file: ${dst}"
        rm -f ${dst}
    fi

    e_info "${src} ====> ${dst}"
    ln -s ${src} ${dst}
    if [ -h ${dst} ];then
        e_ok "linked ${dst}"
        return 0
    else
        e_err "${dst} link failed, try manual"
        exist 1
    fi
}

function package_link() {
    local name="$1"
    local src="${sdir}/${name}"
    if [ ! -z $2 ];then
        src="$2"
    fi
    local dst="${xconf}/${name}"
    if [ ! -z $3 ];then
        dst="$3"
    fi

    if [ ! -d ${src} ];then
        e_err "src(${src}) is not exist, exit"
        return 1
    fi
    do_link ${src} ${dst}
}


function file_link() {
    local src="$1"
    local dst="$2"

    if [ ! -f $src ];then
        return 1
    fi
    do_link $src $dst
}

function file_copy() {
    local src="$1"
    local dst="$2"

    if [ ! -f $src ];then
        return 1
    fi
    cp -f $src $dst
}


function dir_copy() {
    local src="$1"
    local dst="$2"

    if [ -h $dst ];then
        e_err "$dst is exist as link"
    fi

    if [ ! -d ${dst} ];then
        mkdir -p ${dst}
    fi
    cp -r ${src} ${dst}
}