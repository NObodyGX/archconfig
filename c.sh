#!/bin/bash

function tra() {
    local src="aaa/firefox/userChrome.css"
    local dst=$(dirname $src)
    echo "$dst"
}

tra