#!/usr/bin/env bash
set -eux

## Variables
POSTGRES_ROOT_PASSWORD=postgres

#POSTGRES_DB=postgresql
#POSTGRES_USER=postgresql
#POSTGRES_PASSWORD=postgresql

## -----------------------------------------------------------------------------

## Sources
apt-get update
apt-get upgrade -y

## Certificates
apt install -y ca-certificates

## Language
apt install -y locales
locale-gen cs_CZ.UTF-8

## Configuration
apt install -y debconf-utils

## System tools
apt install -y curl zip unzip
#apt install -y wget mc nmon

## IPv6
echo "net.ipv6.conf.all.disable_ipv6=1" > /etc/sysctl.d/ipv6.conf
sysctl -p

## VMware
apt install -y open-vm-tools

## SSH
sed -i 's/#PasswordAuthentication/PasswordAuthentication/' /etc/ssh/sshd_config
#sed -i 's/#PermitEmptyPasswords/PermitEmptyPasswords/' /etc/ssh/sshd_config





## Vim
#apt install -y vim
#cat >/etc/vim/vimrc.local <<'EOF'
#syntax on
#set background=dark
#set esckeys
#set ruler
#set laststatus=2
#set nobackup
#autocmd BufNewFile,BufRead Vagrantfile set ft=ruby
#EOF





## Initialization mc ?????????????????????
## use_internal_edit=1

#cp /vagrant/config/mc/.mc.ini /home/vagrant/
#chown vagrant:vagrant /home/vagrant/.mc.ini
#chmod -R -x /home/vagrant/.mc.ini

## Edit=%var{EDITOR:editor} %f
#cp -p /vagrant/config/mc/mc.ext /home/vagrant/.config/mc/
#chown vagrant:vagrant /home/vagrant/.config/mc/mc.ext
# chmod -R -x /home/vagrant/.config/mc/mc.ext

## -----------------------------------------------------------------------------

## Node.js (latest)
#curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -

## Node.js (LTS)
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

## Node.js
apt install -y nodejs

## Node.js - Yarn (a node module manager)
npm install yarn -g





## Apache
apt install -y apache2
cp /vagrant/symfony/apache.conf /etc/apache2/sites-enabled/000-default.conf

## Apache website permissions
apt install -y libapache2-mpm-itk
a2enmod mpm_itk

## Apache clean URL and caching
a2enmod rewrite expires

#rm -rf /var/www/html
mkdir -p /home/vagrant/workspace/public
echo "Public folder" > /home/vagrant/workspace/public/index.html

## -----------------------------------------------------------------------------

## PHP 7.0
#apt install -y php php-gd php-mbstring php-opcache php-xml php-curl php-zip php-ldap
##apt install -y php-cli php-xdebug libpng-dev
#cp /vagrant/config/php.ini /etc/php/7.0/apache2/conf.d/

## PHP 7.2
apt install -y apt-transport-https lsb-release ca-certificates
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
apt update
## apt-cache search php7.2
apt install -y php7.2 php7.2-gd php7.2-mbstring php7.2-opcache php7.2-xml php7.2-curl php7.2-zip php7.2-ldap
cp /vagrant/symfony/php.ini /etc/php/7.2/apache2/conf.d/

## -----------------------------------------------------------------------------

## PostgreSQL
apt install -y postgresql php-pgsql





## Fixme: password authentication failed (vagrant up --provision)





sudo -u postgres psql -c "ALTER ROLE postgres WITH PASSWORD '$POSTGRES_ROOT_PASSWORD'"

#sudo -u postgres createdb $POSTGRES_DB
#sudo -u postgres createuser $POSTGRES_USER
#sudo -u postgres psql -c "
#  ALTER ROLE $POSTGRES_USER WITH ENCRYPTED PASSWORD '$POSTGRES_PASSWORD';
#  GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO $POSTGRES_USER;
#"

## Notes:
##sudo -u postgres psql -c "CREATE DATABASE $POSTGRES_DB WITH OWNER $POSTGRES_USER;"
##sudo -u postgres psql -c "CREATE DATABASE music ENCODING 'UTF8'  LC_COLLATE 'utf8mb4_czech_ci';"





## Enable password-base authentication
sed -i 's/local.*all.*postgres.*peer/local\tall\t\tpostgres\t\t\t\tmd5/' /etc/postgresql/9.6/main/pg_hba.conf
sed -i 's/local.*all.*all.*peer/local\tall\t\tall\t\t\t\t\tmd5/' /etc/postgresql/9.6/main/pg_hba.conf

## Init the database
#/etc/profile.d/profile.local.sh

## -----------------------------------------------------------------------------

## Adminer (old)
#apt install -y adminer

## Adminer (latest)
mkdir -p /usr/share/adminer/adminer
wget "http://www.adminer.org/latest.php" -O /usr/share/adminer/adminer/index.php
echo '50 2 5 * * /usr/bin/wget "http://www.adminer.org/latest.php" -O /usr/share/adminer/adminer/index.php' > /etc/cron.d/adminer

## Adminer - alias
echo "Alias /adminer /usr/share/adminer/adminer" | sudo tee /etc/apache2/conf-available/adminer.conf
a2enconf adminer.conf
service apache2 restart

## -----------------------------------------------------------------------------

## Development

## Composer (old)
#apt install -y git composer

## Composer (latest)
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

## Setup XDebug
#cp xdebug-docker.ini /usr/local/etc/php/conf.d/
#echo "zend_extension = '$(find / -name xdebug.so 2> /dev/null)'\n$(cat /usr/local/etc/php/conf.d/xdebug-docker.ini)" > /usr/local/etc/php/conf.d/xdebug-docker.ini
#cp /usr/local/etc/php/conf.d/xdebug-docker.ini /etc/php5/cli/conf.d/





## Swap (variant A)
## Enble dynamic swap space to prevent "Out of memory" crashes
apt install -y swapspace

## Swap (variant B)
## https://www.digitalocean.com/community/tutorials/how-to-add-swap-on-ubuntu-14-04
#fallocate -l 4G /swapfile
#chmod 0600 /swapfile
#mkswap /swapfile
#swapon /swapfile
#echo '/swapfile none swap sw 0 0' >> /etc/fstab
#echo vm.swappiness = 10 >> /etc/sysctl.conf
#echo vm.vfs_cache_pressure = 50 >> /etc/sysctl.conf
#sysctl -p

## -----------------------------------------------------------------------------

## Image tools
#apt install -y libjpeg-progs optipng gifsicle php-imagick

## -----------------------------------------------------------------------------

## Services
service apache2 reload
service postgresql reload
#service swapspace status

## -----------------------------------------------------------------------------

## Security





## -----------------------------------------------------------------------------

#mv /var/www/html/index.html /var/www/html/info.html
#rm -rf /var/www/html





#if ! [ -L /var/www ]; then
#  rm -rf /var/www
#  ln -fs /vagrant /var/www
#fi

## -----------------------------------------------------------------------------

## Cleaning
#apt-get clean
#apt-get autoclean
#apt-get -y autoremove
#rm -rf /var/lib/apt/lists/*

## -----------------------------------------------------------------------------

## LDAP
#source ./ldap.sh

## -----------------------------------------------------------------------------

## Fix disk fragmentation (increases compression efficiency)
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
