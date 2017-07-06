Development environment on OSX
==============================

Or how to install Nginx, PHP-FPM, MySQL, phpMyAdmin without dying
-----------------------------------------------------------------

### First, install the life saver, Homebrew!

```bash
xcode-select --install
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
Check for any conflict
```bash
brew doctor
```
then
```bash
brew update && brew upgrade
```

### Next step install PHP-FPM

Juste add PHP-FPM to hombrew formula, install and update your path variable

```bash
brew tap homebrew/dupes
brew tap homebrew/php
brew install --without-apache --with-fpm --with-mysql php56
echo 'export PATH="/usr/local/sbin:$PATH"' >> ~/.zshrc && . ~/.zshrc
```

Add PHP-FPM to auto start local folder, then start it

```bash
mkdir -p ~/Library/LaunchAgents
ln -sfv /usr/local/opt/php56/homebrew.mxcl.php56.plist ~/Library/LaunchAgents/homebrew.mxcl.php.plist
launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.php.plist
```

Some checks
```bash
lsof -Pni4 | grep LISTEN | grep php
```

and you may see something like this
```bash
php-fpm   91492 jerome    6u  IPv4 0xf3c1f5726fa57d3b      0t0  TCP 127.0.0.1:9000 (LISTEN)
php-fpm   95566 jerome    0u  IPv4 0xf3c1f5726fa57d3b      0t0  TCP 127.0.0.1:9000 (LISTEN)
php-fpm   95588 jerome    0u  IPv4 0xf3c1f5726fa57d3b      0t0  TCP 127.0.0.1:9000 (LISTEN)
php-fpm   95594 jerome    0u  IPv4 0xf3c1f5726fa57d3b      0t0  TCP 127.0.0.1:9000 (LISTEN)
php-fpm   95595 jerome    0u  IPv4 0xf3c1f5726fa57d3b      0t0  TCP 127.0.0.1:9000 (LISTEN)
php-fpm   95596 jerome    0u  IPv4 0xf3c1f5726fa57d3b      0t0  TCP 127.0.0.1:9000 (LISTEN)
```

### Let's install MySQL now!

Again use brew... what a life saver!
```bash
brew install mysql
```

and start DB server

```bash
ln -sfv /usr/local/opt/mysql/homebrew.mxcl.mysql.plist ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
```

Why not also use ```mysql_secure_installation ```

### You need phpMyAdmin, why not.

Just set autoconf first
```bash
brew install autoconf
echo 'PHP_AUTOCONF="'$(which autoconf)'"' >> ~/.zshrc && . ~/.zshrc
```

then

```bash
brew install phpmyadmin
```

### Now the great web server...

Install nginx, set auto start services and start it
```bash
brew install nginx
sudo cp -v /usr/local/opt/nginx/*.plist /Library/LaunchDaemons/
sudo chown root:wheel /Library/LaunchDaemons/homebrew.mxcl.nginx.plist
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.nginx.plist
```

You can test your web server, just navigate to [http://127.0.0.1:8080](http://127.0.0.1:8080)

### Diving into nginx settings

First stop your server if is running

```bash
sudo launchctl unload /Library/LaunchDaemons/homebrew.mxcl.nginx.plist
```

And create some folders, you can replace ```/var/www``` with your favorite web development directory

```bash
mkdir -p /usr/local/etc/nginx/logs
mkdir -p /usr/local/etc/nginx/sites-available
mkdir -p /usr/local/etc/nginx/sites-enabled
mkdir -p /usr/local/etc/nginx/conf.d
sudo mkdir -p /var/www
sudo chown :staff /var/www
sudo chmod 775 /var/www
```

Customize you nginx configuration file or use this one

```bash
rm /usr/local/etc/nginx/nginx.conf
curl -L https://gist.githubusercontent.com/jnadaud/bdee126ebd6e13fe632e/raw/nginx.conf -o /usr/local/etc/nginx/nginx.conf
```

Please keep in mind that I set ```worker_processes``` to 40 for my config (10 worker_processes per CPU Core) and in order to increment ```worker_connections``` to 1024 use ulimit -n 1024

Customize your PHP-FPM configuration file or use this one

```bash
curl -L https://gist.githubusercontent.com/jnadaud/cf27cce8f7560565c6a3/raw/php-fpm -o /usr/local/etc/nginx/conf.d/php-fpm
```

And create your virtual hosts

```bash
curl -L https://gist.githubusercontent.com/jnadaud/4c4c8d12f794a58b0ee0/raw/sites-available-default -o /usr/local/etc/nginx/sites-available/default
curl -L https://gist.githubusercontent.com/jnadaud/8b06afa0092d6c0553a9/raw/sites-available-pma -o /usr/local/etc/nginx/sites-available/pma
```

### You need SSL acces, no pb, just set up now SSL part creating keys and virtual host

```bash
mkdir -p /usr/local/etc/nginx/ssl
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=State/L=Town/O=Office/CN=localhost" -keyout /usr/local/etc/nginx/ssl/localhost.key -out /usr/local/etc/nginx/ssl/localhost.crt
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=State/L=Town/O=Office/CN=phpmyadmin" -keyout /usr/local/etc/nginx/ssl/phpmyadmin.key -out /usr/local/etc/nginx/ssl/phpmyadmin.crt
curl -L https://gist.githubusercontent.com/jnadaud/d693e7179989bea973df/raw/sites-available-default-ssl -o /usr/local/etc/nginx/sites-available/default-ssl
```

### Final part

Enable virtual hosts and start nginx server

```bash
ln -sfv /usr/local/etc/nginx/sites-available/default /usr/local/etc/nginx/sites-enabled/default
ln -sfv /usr/local/etc/nginx/sites-available/pma /usr/local/etc/nginx/sites-enabled/pma
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.nginx.plist
```

You have set up SSL part, so enable it

```bash
ln -sfv /usr/local/etc/nginx/sites-available/default-ssl /usr/local/etc/nginx/sites-enabled/default-ssl
```

Check your config with

```bash
sudo nginx -t
```

### Now what else ?

* Install mcrypt
```bash
brew install mcrypt
brew install php56-mcrypt
```

* Install composer globally
```bash
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
```

* Install PHP switcher
```bash
curl -L https://gist.githubusercontent.com/jnadaud/cbfd1ebf38b78e48e481/raw/sphp > /usr/local/bin/sphp
chmod +x /usr/local/bin/sphp
```
