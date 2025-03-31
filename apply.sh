#!/bin/bash
source functions_global.sh

OS=`( lsb_release -ds || cat /etc/*release || uname -o ) 2>/dev/null | head -n1 | tr '[:upper:]' '[:lower:]'`
ARCH=`uname -p`

if [[ "$OS" =~ ^darwin ]]; then
    OS="darwin"
    source functions_macos.sh
elif [[ "$OS" =~ ^ubuntu ]]; then
    OS="linux"
    source functions_linux_ubuntu.sh
else
    echo "Not supported"
    exit 1
fi

init
config_git
install_vim
install_nvm
install_slack
install_chrome
install_sublime_text
install_font_jetbrains-mono
install_vscode
install_vscode_extensions
copy_vscode_settings
install_postman
install_spotify
install_docker
install_ohmyzsh
finish