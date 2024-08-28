# Navigation
function ..    ; cd .. ; end
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end

# Utilities
function grep     ; command grep --color=auto $argv ; end

# mv, rm, cp
abbr rm 'rm -v'
abbr cp 'cp -v'
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

if type -q exa
    alias ls='exa --icons --group-directories-first '
    alias la 'exa --icons --all --group --header --binary --links --group-directories-first '
    alias ll 'exa --icons --long --all --group --header --git --group-directories-first '
    alias ltree='exa  --icons --long --all --group --header --tree --level '
end

# nvm

function nvm
    fenv source ~/.nvm/nvm.sh \; nvm $argv
end

# nobodygx
alias genmd='ncmd genmd .'
if set -q rename
    set -e rename
end
alias rename='ncmd rename '
alias genmdu='ncmd genmd . -u'
alias covertran='mogrify -resize 1280x676 _cover.jpg && identify _cover.jpg'
alias hexor='cd /data/shome && hexo cl && hexo s'
alias hexog='cd /data/shome && hexo gen && cd -'
alias hexocl='cd /data/shome && hexo cl '


function genmdfast --description 'genmd fastly' -a extra
    set -l M_NAME (basename $PWD | cut -d - -f2)
    set -l M_CUR (dirname $PWD)
    set -l M_ARTIST (basename $M_CUR)
    ncmd genmd . -n=$M_NAME -a=$M_ARTIST
end

function covercal --description 'cal cover width and height'
    set -l jw (jpeginfo _cover.jpg | awk '{print $2}')
    set -l jh (jpeginfo _cover.jpg | awk '{print $4}')
    set -l njh (math round (math $jw \* 0.528))
    echo "tran ($jw, $njh), tran $jw --> $njh"
end
