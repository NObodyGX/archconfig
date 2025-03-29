# 配置路径不用缩写
set -g fish_prompt_pwd_dir_length 0
export TERMINFO=/usr/share/terminfo

source "$HOME/.config/fish/nobodygx/falias.fish"

set -l my_core_function_path "$HOME/.config/fish/plugins/colorize" "$HOME/.config/fish/plugins/gxcommon" "$HOME/.config/fish/plugins/nobodygx"
# Autoload core library
set fish_function_path $fish_function_path[1] \
    $my_core_function_path \
    $fish_function_path[2..-1]
if status is-interactive
    # Commands to run in interactive sessions can go here
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1
#if test -f /opt/miniconda3/bin/conda
#    eval /opt/miniconda3/bin/conda "shell.fish" "hook" $argv | source
#else
#    if test -f "/opt/miniconda3/etc/fish/conf.d/conda.fish"
#        . "/opt/miniconda3/etc/fish/conf.d/conda.fish"
#    else
#        set -x PATH "/opt/miniconda3/bin" $PATH
#    end
#end
# <<< conda initialize <<<
