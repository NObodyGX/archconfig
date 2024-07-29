export ZINIT_HOME="${HOME}/.config/zsh/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit compinit && compinit 
(( ${+_comps} )) && _comps[zinit]=_zinit

### User config here ###
## Load prompt theme
zinit light denysdovhan/spaceship-prompt
## xun plugins
zinit wait lucid light-mode for \
    hcgraf/zsh-sudo \
    zsh-users/zsh-completions \
    Freed-Wu/zsh-command-not-found
# Load these plugins 1 second after prompt loaded
zinit wait="1" lucid light-mode for \
    Aloxaf/fzf-tab \
    zsh-users/zsh-autosuggestions \
    zdharma/history-search-multi-word \
    skywind3000/z.lua \
    wfxr/forgit \
    MichaelAquilina/zsh-you-should-use \
    hlissner/zsh-autopair \
    zdharma/fast-syntax-highlighting \




# force saving all history
export HISTSIZE=1000000000
export SAVEHIST=1000000000
setopt EXTENDED_HISTORY

