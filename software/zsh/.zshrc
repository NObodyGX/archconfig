export ZINIT_HOME="${HOME}/.config/zsh/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

source "${ZINIT_HOME}/zinit.zsh"
source "${HOME}/.config/zsh/nobodygx/alias.zsh"
source "${HOME}/.config/zsh/nobodygx/devenv.zsh"

[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

### User config here ###
## Load prompt theme
zinit light spaceship-prompt/spaceship-prompt
## xun plugins
## notice: syntax-highlighting should be end
zinit wait lucid light-mode for \
    supercrabtree/k \
    zsh-users/zsh-completions \
    zsh-users/zsh-autosuggestions \
    Freed-Wu/zsh-command-not-found \
    Aloxaf/fzf-tab \
    MichaelAquilina/zsh-you-should-use \
    hlissner/zsh-autopair \
    zsh-users/zsh-syntax-highlighting \


# force saving all history
export HISTSIZE=1000000000
export SAVEHIST=1000000000
setopt EXTENDED_HISTORY

# keymap
# use `read -k` to get a key sequence
# or `cat + enter + the-key`
typeset -gA keys=(
  Up              '^[[A'
  Down            '^[[B'
  Home            '^[[H'
  End             '^[[F'
  Delete          '^[[3~'
  Escape          '^['

  Ctrl+Delete     '^[[3;5~'
  Ctrl+K          '^K'
)
bindkey -- "${keys[Delete]}" delete-char
bindkey -- "${keys[Ctrl+Delete]}" delete-char
bindkey -- "${keys[Home]}" beginning-of-line
bindkey -- "${keys[End]}" end-of-line
bindkey "${keys[Ctrl+K]}" kill-whole-line

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey -- "${keys[Up]}" up-line-or-beginning-search
bindkey -- "${keys[Down]}" down-line-or-beginning-search

zle -N sudo-command-line
sudo-command-line() {
  if [[ $BUFFER == sudo\ * ]]; then
    LBUFFER="${LBUFFER#sudo }"
  else
    LBUFFER="sudo $LBUFFER"
  fi
}
bindkey "${keys[Escape]}${keys[Escape]}" sudo-command-line
# keymap end

