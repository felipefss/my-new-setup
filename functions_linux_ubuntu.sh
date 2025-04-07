#!/bin/bash

init() {
	echo "Starting configuration for Ubuntu"
	
	install_apt_packages
}

fix_cedilha() {
	echo "Fixing cedilha character"
	
	sh fix_cedilla.sh
}

install_vim() {
	echo "Installing vim"
	
	sudo apt install -y vim
	
	cp -v vimrc ~/.vimrc
}

install_apt_packages() {
	echo "Installing apt packages"
	
	sudo apt update
	sudo apt install -y apt-transport-https
}

install_zsh() {
	echo "Installing zsh"
	
	sudo apt install zsh
	
	# Make it the default shell
	chsh -s $(which zsh)
}

install_sublime_text() {
	echo "Installing Sublime Text"
	
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null

	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

	sudo apt update
	sudo apt install -y sublime-text
}

install_font_jetbrains-mono() {
	echo "Installing font Jetbrains Mono"
	
	curl --location https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip \
		--output Jetbrains.zip
	
	unzip Jetbrains.zip -d ./jetbrains
	cp -arv jetbrains/fonts/* ~/.local/share/fonts
	fc-cache -f -v
	
	# Clean up
	rm -rf jetbrains Jetbrains.zip
}

install_vscode() {
	echo "Installing VS Code"
	
	sudo snap install code --classic
}

copy_vscode_settings() {
	if command -v code &> /dev/null ; then
        echo "Copying VS Code settings"
        cp "$DOTFILES/vscode_settings.json" "$HOME/.config/Code/User/settings.json"
    fi
}

install_spotify() {
	echo "Installing Spotify"
	
	sudo snap install spotify
}

install_docker() {
	echo "Installing Docker Desktop"
	
	# Add Docker's official GPG key:
	sudo apt-get update
	sudo apt-get install -y ca-certificates curl
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc

	# Add the repository to Apt sources:
	echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
	  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
	  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	
	curl --location https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb --output docker.deb
	
	sudo apt update
	sudo apt install -y ./docker.deb
	
	rm docker.deb
}

