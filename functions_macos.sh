#!/bin/sh

init() {
  echo "Starting configuration for macOS"
  configure_keyboard
  install_homebrew
  install_whatsapp
  install_amazon_q
  install_scroll_reverser
}

finish() {
  configure_dock
}

configure_keyboard() {
  echo "Configuring keyboard"

  defaults write NSGlobalDomain "ApplePressAndHoldEnabled" -bool "false";

  # Use F5 to reload page in Chrome
  defaults write com.google.Chrome NSUserKeyEquivalents -dict-add "Reload This Page" "\\Uf708";

}

install_homebrew() {
    if command -v brew &> /dev/null ; then
        echo "Homebrew is already installed, skipping"
        return
    fi

    echo "Installing homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $HOME/.profile
    eval "$(/opt/homebrew/bin/brew shellenv)"
}

install_slack() {
    if [ -d "/Applications/Slack.app"  ]; then
        echo "Slack is already installed, skipping"
        return
    fi

    echo "Installing Slack"

    # download latest Slack disk image
    curl --location "https://slack.com/api/desktop.latestRelease?arch=universal&variant=dmg&redirect=true" \
        --output Slack.dmg

    # mount downloaded disk image
    hdiutil attach Slack.dmg -nobrowse -readonly

    echo "copying Slack to /Applications"
    cp -R /Volumes/Slack/Slack.app /Applications/

    # unmount disk image
    hdiutil detach /Volumes/Slack/ -force
}

install_chrome() {
    if [ -d "/Applications/Google Chrome.app"  ]; then
        echo "Google Chrome is already installed, skipping"
        return
    fi

    echo "Installing Google Chrome"

    curl --location "https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg" \
        --output Chrome.dmg

    hdiutil attach Chrome.dmg -nobrowse -readonly
    cp -R "/Volumes/Google Chrome/Google Chrome.app" /Applications/
    hdiutil detach "/Volumes/Google Chrome/" -force
    rm Chrome.dmg
}

install_sublime_text() {
    if [ -d "/Applications/Sublime Text.app"  ]; then
        echo "Sublime Text is already installed, skipping"
        return
    fi

    echo "Installing Sublime Text"

    curl --location "https://download.sublimetext.com/sublime_text_build_4180_mac.zip" \
        --output SublimeText.zip
    
    unzip SublimeText.zip
    mv "Sublime Text.app" /Applications
    rm SublimeText.zip
}

install_vscode() {
    if [ -d "/Applications/Visual Studio Code.app"  ]; then
        echo "Visual Studio Code is already installed, skipping"
        return
    fi

    echo "Installing VS Code"

    curl --location "https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal" \
        --output VSCode.zip

    unzip VSCode.zip
    mv "Visual Studio Code.app" /Applications
    rm VSCode.zip
}

copy_vscode_settings() {
    if command -v code &> /dev/null ; then
        echo "Copying Visual Studio Code settings"
        cp "$DOTFILES/vscode_settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
    fi
}

install_font_jetbrains-mono() {
    echo "Installing JetBrains Mono font"

    brew install --cask font-jetbrains-mono
}

install_whatsapp() {
    if [ -d "/Applications/WhatsApp.app"  ]; then
        echo "WhatsApp is already installed, skipping"
        return
    fi

    echo "Installing WhatsApp"

    curl --location "https://web.whatsapp.com/desktop/mac_native/release/?configuration=Release" \
        --output WhatsApp.dmg

    hdiutil attach WhatsApp.dmg -nobrowse -readonly
    cp -R "/Volumes/WhatsApp/WhatsApp.app" /Applications/
    hdiutil detach "/Volumes/WhatsApp/" -force
    rm WhatsApp.dmg
}

install_postman() {
    if [ -d "/Applications/Postman.app"  ]; then
        echo "Postman is already installed, skipping"
        return
    fi
    
    echo "Installing Postman"

    if [[ "$ARCH" == "arm"  ]]; then
        curl --location "https://dl.pstmn.io/download/latest/osx_arm64" --output postman.zip
    else
        curl --location "https://dl.pstmn.io/download/latest/osx_64" --output postman.zip
    fi

    unzip postman.zip
    mv Postman.app /Applications/
    rm postman.zip
}

install_spotify() {
    if [ -d "/Applications/Spotify.app"  ]; then
        echo "Spotify is already installed, skipping"
        return
    fi

    echo "Downloading Spotify"
    curl -O https://download.scdn.co/SpotifyInstaller.zip
    unzip SpotifyInstaller.zip && rm SpotifyInstaller.zip
    echo "⚠️ Spotify was downloaded, but you need to install it manually!"
    open "Install Spotify.app" &
}

install_docker() {
    if command -v docker &> /dev/null ; then
        echo "Docker is already installed, skipping"
        return
    fi

    echo "Installing Docker Desktop"
    brew install --cask docker
}

install_vim() {
  if ! command -v vim &> /dev/null ; then
    echo "Installing vim"
    brew install vim
  fi
}

install_amazon_q() {
  if [ -d "/Applications/Amazon Q.app" ]; then
    echo "Amazon Q is already installed, skipping"
    return
  fi

  echo "Installing Amazon Q"
  curl --location "https://desktop-release.codewhisperer.us-east-1.amazonaws.com/latest/Amazon Q.dmg" \
       --output AmazonQ.dmg

  hdiutil attach AmazonQ.dmg -nobrowse -readonly
  cp -R "/Volumes/Amazon Q/Amazon Q.app" /Applications/
  hdiutil detach "/Volumes/Amazon Q/" -force
  rm AmazonQ.dmg
}

install_scroll_reverser() {
  if [ -d "/Applications/Scroll Reverser.app" ]; then
    echo "Scroll Reverser is already installed, skipping"
    return
  fi

  echo "Installing Scroll Reverser"
  curl --location "https://pilotmoon.com/downloads/ScrollReverser-1.9.zip" \
       --output ScrollReverser.zip

  unzip ScrollReverser.zip
  mv "Scroll Reverser.app" /Applications/
  rm ScrollReverser.zip
}

configure_dock() {
    echo "Configuring Dock"

    if ! command -v dockutil &> /dev/null ; then
        brew install dockutil
    fi

    apps_to_add=()
    apps_to_add+=("/System/Applications/Launchpad.app")
    apps_to_add+=("/System/Applications/Calendar.app")
    apps_to_add+=("/Applications/Spotify.app")
    apps_to_add+=("/Applications/Slack.app")
    apps_to_add+=("/Applications/Google Chrome.app")
    apps_to_add+=("/Applications/WhatsApp.app")
    apps_to_add+=("/Applications/Visual Studio Code.app")
    apps_to_add+=("/Applications/Sublime Text.app")
    apps_to_add+=("/System/Applications/System Settings.app/")
    apps_to_add+=("/System/Applications/Utilities/Terminal.app")

    # Remove all of them so we can re-add in order
    for app in "${apps_to_add[@]}"; do
        if dockutil -f "$app" > /dev/null; then 
            echo "Removing $app from Dock"
            dockutil --no-restart  --remove "$app"
        fi
    done

    for app in "${apps_to_add[@]}"; do
        dockutil --no-restart  -a "$app"
    done

    killall Dock
}
