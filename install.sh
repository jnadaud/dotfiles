#!/usr/bin/env bash

#Change computer name
sudo scutil --set ComputerName "Nebula"
sudo scutil --set HostName "Nebula"
sudo scutil --set LocalHostName "Nebula"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "Nebula"

#Prepare ssh repo
mkdir ~/.ssh
chmod 700 ~/.ssh

#Install Homebrew
xcode-select --install
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew tap homebrew/cask-cask

ln -s $(pwd)/Development/dotfiles/env/.gitconfig ~/.
ln -s $(pwd)/Development/dotfiles/env/.gitignore ~/.
ln -s $(pwd)/Development/dotfiles/env/.aliases ~/.

#Install ZSH
brew install zsh zsh-completions
brew cask install iterm2
chsh -s /bin/zsh

#Install utils
brew install terminal-notifier tmate htop the_silver_searcher glances unrar p7zip gpg
brew cask install iina whatsapp dropbox spotify transmission the-unarchiver appcleaner docker

#Install languages
brew install go crystal node

#Install dev tools
brew install mkcert
brew cask install slack insomnia tableplus sequel-pro ngrok visual-studio-code 
#Install symfony cli
curl -sS https://get.symfony.com/cli/installer | bash

#Install Python 3
#brew install python

#Install devops tools
brew install terraform ansible

#Install composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer

#Remove apache
sudo apachectl -k stop
sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist

#Update PHP
brew install php@8.0

brew cleanup

#Install prompt and fonts
npm install --global pure-prompt
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts

#Update osx conf
defaults write com.apple.Terminal FocusFollowsMouse -string YES

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
#defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Make dock transparent
defaults write com.apple.dock hide-mirror -bool true

#Install Oh My ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm -f .zshrc
ln -s $(pwd)/Development/dotfiles/env/.zshrc ~/.

sudo shutdown -r now
