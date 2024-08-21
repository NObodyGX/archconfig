# Navigation
function ..    ; cd .. ; end
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end

# Utilities
function grep     ; command grep --color=auto $argv ; end

# mv, rm, cp
abbr mv 'mv -v'
abbr rm 'rm -v'
abbr cp 'cp -v'
# mkdir
alias mkdir='mkdir -pv'
alias df='df -h'
alias du='du -ch'
alias free='free -m'


alias G='git clone --depth=1 '
alias k='exa'
alias kk='du -sh *'

if type -q exa
    alias l exa
    alias la 'exa --long --all --group --header --binary --links'
    alias ll 'exa --long --all --group --header --git'
    alias ltree='exa --long --all --group --header --tree --level '
end


# nobodygx

alias genmd='ncmd genmd .'
if set -q rename
    set -e rename
end
alias rename='ncmd rename '
alias covertran='mogrify -resize 1280x676 _cover.jpg && identify _cover.jpg'


function genmdfast --description 'genmd fastly' -a extra
    set -l M_NAME (basename $PWD | cut -d - -f2)
    set -l M_CUR (dirname $PWD)
    set -l M_ARTIST (basename $M_CUR)
    ncmd genmd . -n=$M_NAME -a=$M_ARTIST
end
