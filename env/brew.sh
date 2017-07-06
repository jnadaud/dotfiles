#!/usr/bin/env bash
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update && brew upgrade
brew install git
brew install hub
brew install terminal-notifier
sudo gem install compass
sudo gem install sass
