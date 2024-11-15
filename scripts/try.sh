#!/bin/bash

#=============== env =================#
if [ -z "$xhome" ]; then
    xhome="$HOME"
fi
if [ -z "$xconf" ]; then
    xconf="${xhome}/.config"
fi
if [ -z "$pwd" ]; then
    pwd=$(
        cd "$(dirname "$0")" || exit
        pwd
    )
fi
if [ -z "$sdir" ]; then
    sdir="$pwd/../software"
fi
aur="yay "
#=============== env =================#

#============== check ================#

function check_by_grep_cat() {
    local dst="$1"
    local todo="$2"
    cmd=$("cat $dst")
    if [ ! -f "$dst" ]; then
        return 2
    fi
    if ! grep -q "$todo" "$dst"; then
        return 1
    fi
    return 0
}

function check_by_grep_cat_sudo() {
    local dst="$1"
    local todo="$2"
    local cmd=""
    if [ ! -f "$dst" ]; then
        return 2
    fi
    cmd=$(sudo_run "cat $dst")
    if ! echo "$cmd" | grep -q "$todo"; then
        return 1
    fi
    return 0
}

function check_str_endswith() {
    local text="$1"
    local todo="$2"
    if [ -z "$text" ];then
        echo "2"
        return 2
    fi
    if [ -z "$todo" ];then
        echo "3"
        return 3
    fi
    if [[ $text = "*${todo}" ]]; then
        echo "0"
        return 0
    fi
    echo "1"
    return 1
}

#============== check ================#

#=============== try =================#
function try_link() {
    local src="$1"
    local dst="$2"

    if [ -h "$dst" ]; then
        print_ok "linked ${dst}"
        return 0
    fi

    if [ -d "$dst" ]; then
        print_info "delete dir: ${dst}"
        rm -rf "${dst}"
    elif [ -f "${dst}" ]; then
        print_info "delete file: ${dst}"
        rm -f "${dst}"
    fi

    print_info "${src} ====> ${dst}"
    ln -s "${src}" "${dst}"
    if [ -h "${dst}" ]; then
        print_ok "linked ${dst}"
        return 0
    else
        print_err "${dst} link failed, try manual"
        exist 1
    fi
}

function try_link_file() {
    local src="$1"
    local dst="$2"

    if [ ! -f "$src" ]; then
        return 1
    fi

    try_link "$src" "$dst"
}

function try_link_dir() {
    local src="$1"
    local dst="$2"

    if [ ! -d "$src" ]; then
        return 1
    fi

    try_link "$src" "$dst"
}

function try_copy_file() {
    local src="$1"
    local dst="$2"

    if [ ! -f "$src" ]; then
        return 1
    fi
    cp -f "$src" "$dst"
}

function try_copy_dir() {
    local src="$1"
    local dst="$2"

    if [ -h "$dst" ]; then
        print_err "$dst is exist as link"
    fi

    if [ ! -d "$dst" ]; then
        mkdir -p "$dst"
    fi
    cp -r "$src" "$dst"
}

function try_mkdir() {
    local dst="$1"
    if [ ! -d "$dst" ]; then
        mkdir -p "$dst"
    fi
}

function sudo_run() {
    sudo -u root -H sh -c "$1"
}

function try_add_text() {
    local content="$1"
    local dst="$2"
    if [ ! -f "$dst" ]; then
        echo "" >"$dst"
    fi
    if ! grep -q "$content" "$dst"; then
        echo "$content" >>"$dst"
    fi
}

function try_add_text_sudo() {
    local content="$1"
    local dst="$2"
    if [ ! -f "$dst" ]; then
        sudo_run "touch $dst"
    fi
    if ! grep -q "$content" "$dst"; then
        sudo_run "echo $content >> $dst"
    fi
}

function try_mv() {
    local p="${xhome}"
    if [ -d "${p}/$1" ]; then
        mv "${p}/$1" "${p}/$2"
    fi
}

function package_check() {
    local cmd
    cmd=$($aur -Q "$1")
    if [ -z "${cmd}" ]; then
        return 1
    fi
    return 0
}

function package_install() {
    local pkg="$1"
    local pname="$2"
    if [ -z "$pname" ]; then
        pname=$pkg
    fi

    if ! package_check "$pname"; then
        print_info "start install $pkg"
        $aur -S "$pkg" --noconfirm --quiet >/dev/null 2>&1
    fi
    if ! package_check "$pname"; then
        print_err "install ${pkg}. try manual..."
        return 1
    fi
    print_ok "installed $pkg"
}

function package_link() {
    local name="$1"
    local src="${sdir}/${name}"
    if [ -n "$2" ]; then
        src="$2"
    fi
    local dst="${xconf}/${name}"
    if [ -n "$3" ]; then
        dst="$3"
    fi

    if [ ! -d "$src" ]; then
        print_err "src(${src}) is not exist, exit"
        return 1
    fi
    try_link "$src" "$dst"
    print_ok "linked $src ==> $dst"
}
#=============== try =================#
