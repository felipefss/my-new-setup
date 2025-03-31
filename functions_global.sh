#!/bin/sh

# Those functions work in macOS or Linux

DOTFILES=`pwd`

install_ohmyzsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing oh-my-zsh unattended"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        cat "$DOTFILES/zshrc" > ~/.zshrc
    fi

    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
        echo "Installing zsh-autosuggestions"
        git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    fi

    if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
        echo "Installing zsh theme powerlevel10k"
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    fi
}

install_nvm() {
    if [ ! -d "$HOME/.nvm" ]; then
        echo "Installing nvm"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    fi
}

install_vscode_extensions() {
    if command -v code &> /dev/null ; then
        echo "Installing Visual Studio Code extensions"
        cat "$DOTFILES/vscode_extensions.txt" | xargs -L 1 code --install-extension
    fi
}

config_git() {
    if command -v git &> /dev/null ; then
        echo "Installing git"

        sudo add-apt-repository ppa:git-core/ppa
        sudo apt update; sudo apt install -y git
    fi

    echo "Copying git config"

    cp gitconfig ~/.gitconfig
}