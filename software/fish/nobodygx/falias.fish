set -U fish_greeting

# Navigation
function ..
    cd ..
end
function ...
    cd ../..
end
function ....
    cd ../../..
end
function .....
    cd ../../../..
end

# Utilities
function grep
    command grep --color=auto $argv
end

# mv, rm, cp
abbr rm 'rm -vrf'
abbr cp 'cp -v'
abbr q exit
abbr clr clear
# normal

alias mkdir='mkdir -pv'
alias df='df -h'
alias du='du -ch'
alias free='free -m'
alias k='exa'
alias kk='du -sh *'
# system
abbr upgrade 'yay -Syyu --noconfirm'
alias ca='conda activate '
alias yays='yay -Ss '
alias yayS='yay -S --needed '
alias yayr='yay -Rns '
alias yayR='yay -Rnsc '
alias yayq='yay -Q | grep '
alias kk='du -sh *'
alias G='git clone --depth=1 '
alias webdav='rclone serve webdav --addr 0.0.0.0:17781 '

# cp mv
alias gcp='rsync -avh --progress '
# fish
alias ex='extract'

# gx
###############################################################
alias mdone='ncmd shell file-mark --mode done'
alias mtodo='ncmd shell file-mark --mode todo'
alias mhot='ncmd shell file-mark --mode hot'
alias m100='ncmd shell file-mark --mode perfect'
alias mstar='ncmd shell file-mark --mode star'
alias mshort='ncmd shell file-mark --mode short'
alias mclean='ncmd shell file-mark --mode clean'
alias dmv='ncmd shell dir-index'
alias dsort='ncmd shell dir-sort . --quiet && ls'
alias genmd='ncmd genmd .'
if set -q rename
    set -e rename
end
alias genmdu='ncmd genmd . -u'
alias covertran='mogrify -resize 1280x676 _cover.jpg && identify _cover.jpg'
alias hexor='cd /data/shome && hexo cl && hexo s'
alias hexog='cd /data/shome && hexo gen && cd -'
alias hexocl='cd /data/shome && hexo cl'
function dn --description "a fast op to go next dir"
    ncmd shell dir-next .
    if test -f /tmp/ncmd_target_dir
        source /tmp/ncmd_target_dir
    end
    ls
end
function dext --description "mv file from a dir and rm dir"
    set -l l_dir $argv[1]
    if ! test -d $l_dir
        echo "error input dir"
        returnD
    end
    mv $l_dir/* .
    rm -rf $l_dir
end
###############################################################

# file list
if type -q exa
    alias ls='exa --icons --group-directories-first '
    alias la 'exa --icons --all --group --header --binary --links --group-directories-first '
    alias ll 'exa --icons --long --all --group --header --git --group-directories-first'
    alias lls 'exa --icons --long --all --group --header --git --group-directories-first --total-size'
    alias ltree='exa  --icons --long --all --group --header --tree --level '
end

# nvm

function nvm
    fenv source ~/.nvm/nvm.sh \; nvm $argv
end

function clear_history --description 'clear txt read history'
    rm -f '/home/xun/.local/share/recently-used.xbel'
end

function loadresdisk --description 'load res disk'
    # 仅在无外挂硬盘的时候启动
    if test (ls "/run/media/xun/" | wc -l) -ne 0
        echo "media is running."
        return 0
    end
    if test (ls "/home/xun/env/mount/total/" | wc -l) -ne 0
        echo "mount dir is full."
        return 0
    end
    set -l disk "$argv[1]"
    sudo mount -o gid=xun,uid=xun,fmask=113,dmask=002 /dev/$disk /home/xun/env/mount/total
    ls /home/xun/env/mount/total
end

function ren --description 'rename files by ncmd rename'
    ncmd rename . $argv
    chmod -x (fd --type file .)
end

function coverinfo --description 'cal cover width and height'
    set -l jw (jpeginfo _cover.jpg | awk '{print $2}')
    set -l jh (jpeginfo _cover.jpg | awk '{print $4}')
    set -l njh (math round (math $jw \* 0.528))
    set -l ncut (math $jh - $njh)
    set -l nncmd (string join -n '' $jw "x" $njh '+0+' $ncut)
    echo "tran ($jw, $jh) --> ($jw, $njh) || $ncut"
    echo "magick _cover.jpg -crop $nncmd _cover.jpg"
end

function covertran --description 'transform cover with sp raido'
    mogrify -resize 1280x676 _cover.jpg
    identify _cover.jpg
end
