set -U fish_greeting

# Navigation
function ..    ; cd .. ; end
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end

# Utilities
function grep     ; command grep --color=auto $argv ; end

# mv, rm, cp
abbr rm 'rm -vrf'
abbr cp 'cp -v'
abbr q  'exit'
abbr clr 'clear'
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

# cp mv
alias gcp='rsync -avh --progress '
# fish
alias ex='extract'

if type -q exa
    alias ls='exa --icons --group-directories-first '
    alias la 'exa --icons --all --group --header --binary --links --group-directories-first '
    alias ll 'exa --icons --long --all --group --header --git --group-directories-first --total-size'
    alias ltree='exa  --icons --long --all --group --header --tree --level '
end

# nvm

function nvm
    fenv source ~/.nvm/nvm.sh \; nvm $argv
end

# nobodygx
set ii "/data/ztaste/01-image"
alias genmd='ncmd genmd .'
if set -q rename
    set -e rename
end
alias genmdu='ncmd genmd . -u'
alias covertran='mogrify -resize 1280x676 _cover.jpg && identify _cover.jpg'
alias hexor='cd /data/shome && hexo cl && hexo s'
alias hexog='cd /data/shome && hexo gen && cd -'
alias hexocl='cd /data/shome && hexo cl '

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
