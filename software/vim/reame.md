# vim 配置

vim 的配置路径分为如下：

```
system vimrc file: "/etc/vimrc"

user vimrc file: "$HOME/.vimrc"
2nd user vimrc file: "~/.vim/vimrc"
3rd user vimrc file: "~/.config/vim/vimrc"

user exrc file: "$HOME/.exrc"
defaults file: "$VIMRUNTIME/defaults.vim"
fall-back for $VIM: "/usr/share/vim"
```


## use Vundle

```shell
mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# add this into vimrc

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" nerdtree 文件树
Plug 'scrooloose/nerdtree'

Plug 'ap/vim-css-color'
call vundle#end() 
```