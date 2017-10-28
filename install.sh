#!/usr/bin/env bash

mkdir ~/.ssh
chmod 700 ~/.ssh

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

brew install terminal-notifier tmate go crystal node htop thefuck the_silver_searcher glances
brew cask install keybase slack iina insomnia virtualbox tableplus sequel-pro spectacle ngrok enpass visual-studio-code

#Install prompt
npm install --global pure-prompt

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

brew cleanup

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

sudo shutdown -r now
