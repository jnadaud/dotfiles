#!/usr/bin/env bash

#Prepare ssh repo
mkdir ~/.ssh
chmod 700 ~/.ssh

#Speed up terminal key
defaults write NSGlobalDomain KeyRepeat -int 1

xcode-select --install
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew tap caskroom/cask

ln -s $(pwd)/env/.gitconfig ~/.
ln -s $(pwd)/env/.gitignore ~/.
ln -s $(pwd)/env/.zshrc ~/.
ln -s $(pwd)/env/.alias ~/.

#Install ZSH
brew install zsh zsh-completions
brew cask install iterm2
chsh -s /bin/zsh

#Install utils
brew install terminal-notifier tmate htop thefuck the_silver_searcher glances
brew cask install iina spectacle enpass telegram spotify transmission the-unarchiver

#Install languages
brew install go crystal node

#Install dev tools
brew install mkcert wellington
brew cask install keybase slack insomnia virtualbox tableplus sequel-pro ngrok visual-studio-code

#Install gitbook
npm install gitbook-cli -g
brew cask install gitbook-editor

sudo easy_install pip

#Install composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer

#Install Docker
brew install docker docker-machine docker-compose docker-machine-nfs
docker-machine create --driver=virtualbox --virtualbox-cpu-count "4" --virtualbox-disk-size "30000" default
docker-machine-nfs default

#Remove apache
sudo apachectl -k stop
sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist

#Update PHP
brew install php@7.3

brew cleanup

#Install prompt and fonts
npm install --global pure-prompt
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts

#Install Oh My ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#Update osx conf
defaults write com.apple.Terminal FocusFollowsMouse -string YES
defaults write NSGlobalDomain KeyRepeat -int 1

sudo shutdown -r now
