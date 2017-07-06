#!/usr/bin/env bash
brew tap homebrew/dupes
brew tap homebrew/php
brew install --without-apache --with-fpm --with-mysql php56
echo 'export PATH="/usr/local/sbin:$PATH"' >> ~/.zshrc && . ~/.zshrc
mkdir -p ~/Library/LaunchAgents
ln -sfv /usr/local/opt/php56/homebrew.mxcl.php56.plist ~/Library/LaunchAgents/homebrew.mxcl.php.plist
launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.php.plist
brew install mysql
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
brew install autoconf
echo 'PHP_AUTOCONF="'$(which autoconf)'"' >> ~/.zshrc && . ~/.zshrc
brew install phpmyadmin
brew install nginx
sudo cp -v /usr/local/opt/nginx/*.plist /Library/LaunchDaemons/
sudo chown root:wheel /Library/LaunchDaemons/homebrew.mxcl.nginx.plist
mkdir -p /usr/local/etc/nginx/logs
mkdir -p /usr/local/etc/nginx/sites-available
mkdir -p /usr/local/etc/nginx/sites-enabled
mkdir -p /usr/local/etc/nginx/conf.d
mkdir -p /usr/local/etc/nginx/ssl
sudo mkdir -p /var/www
sudo chown :staff /var/www
sudo chmod 775 /var/www
rm /usr/local/etc/nginx/nginx.conf
curl -L https://gist.githubusercontent.com/jnadaud/bdee126ebd6e13fe632e/raw/nginx.conf -o /usr/local/etc/nginx/nginx.conf
curl -L https://gist.githubusercontent.com/jnadaud/cf27cce8f7560565c6a3/raw/php-fpm -o /usr/local/etc/nginx/conf.d/php-fpm
curl -L https://gist.githubusercontent.com/jnadaud/4c4c8d12f794a58b0ee0/raw/sites-available-default -o /usr/local/etc/nginx/sites-available/default
curl -L https://gist.githubusercontent.com/jnadaud/8b06afa0092d6c0553a9/raw/sites-available-pma -o /usr/local/etc/nginx/sites-available/pma
mkdir -p /usr/local/etc/nginx/ssl
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=State/L=Town/O=Office/CN=localhost" -keyout /usr/local/etc/nginx/ssl/localhost.key -out /usr/local/etc/nginx/ssl/localhost.crt
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=State/L=Town/O=Office/CN=phpmyadmin" -keyout /usr/local/etc/nginx/ssl/phpmyadmin.key -out /usr/local/etc/nginx/ssl/phpmyadmin.crt
curl -L https://gist.githubusercontent.com/jnadaud/d693e7179989bea973df/raw/sites-available-default-ssl -o /usr/local/etc/nginx/sites-available/default-ssl
ln -sfv /usr/local/etc/nginx/sites-available/default /usr/local/etc/nginx/sites-enabled/default
ln -sfv /usr/local/etc/nginx/sites-available/pma /usr/local/etc/nginx/sites-enabled/pma
ln -sfv /usr/local/etc/nginx/sites-available/default-ssl /usr/local/etc/nginx/sites-enabled/default-ssl
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.nginx.plist

#install mcrypt
brew install mcrypt
brew install php56-mcrypt

# install composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# install PHP Switcher

curl -L https://gist.githubusercontent.com/jnadaud/cbfd1ebf38b78e48e481/raw/sphp > /usr/local/bin/sphp
chmod +x /usr/local/bin/sphp

# install PHPUnit

curl https://phar.phpunit.de/phpunit.phar -o phpunit.phar
chmod +x phpunit.phar
mv phpunit.phar /usr/local/bin/phpunit
