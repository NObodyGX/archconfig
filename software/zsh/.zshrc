export ZINIT_HOME="${HOME}/.config/zsh/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

source "${ZINIT_HOME}/zinit.zsh"
source "${HOME}/.config/zsh/nobodygx/alias.zsh"
source "${HOME}/.config/zsh/nobodygx/devenv.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

### User config here ###
## Load prompt theme
zinit light denysdovhan/spaceship-prompt
## xun plugins
zinit wait lucid light-mode for \
    hcgraf/zsh-sudo \
    supercrabtree/k \
    zsh-users/zsh-completions \
    Freed-Wu/zsh-command-not-found \
    Aloxaf/fzf-tab \
    MichaelAquilina/zsh-you-should-use \
    hlissner/zsh-autopair \
    zdharma/fast-syntax-highlighting \
    

# force saving all history
export HISTSIZE=1000000000
export SAVEHIST=1000000000
setopt EXTENDED_HISTORY

# keymap
# see key u want: ``cat`` + ``enter`` + ``the-key``
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char
# keymap end

