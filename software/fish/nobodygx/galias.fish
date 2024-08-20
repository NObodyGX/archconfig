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


alias G "git clone --depth=1 "
alias k exa

if type -q exa
    alias l exa
    alias la 'exa --long --all --group --header --binary --links'
    alias ll 'exa --long --all --group --header --git'
    alias ltree='exa --long --all --group --header --tree --level'
end