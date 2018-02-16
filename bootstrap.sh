#!/bin/bash

#
# i'm not clear on how to best handle errors from inside the bootstrap file
#

#
# TODO: add cmd option or env override of this password
#
MYSQLPW="password"

#
# Install packages
#
sudo apt-get -y install software-properties-common
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
sudo add-apt-repository -y 'deb [arch=amd64,i386,ppc64el] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu trusty main'

# do system update
sudo apt-get -y update

#
# turn off annoying password prompt
#

# thanks: https://gist.github.com/sheikhwaqas/9088872
export DEBIAN_FRONTEND="noninteractive"
echo "mariadb-server mysql-server/root_password password password" | sudo debconf-set-selections
echo "mariadb-server mysql-server/root_password_again password password" | sudo debconf-set-selections

# install mariadb
sudo apt-get -y install mariadb-server

# install nginx
sudo apt-get -y install nginx

# install php5 and tools
sudo apt-get -y install php5 php5-fpm php5-mysql

# ensure it is running
sudo service mysql start

##
## post-install setup, configure root user and remove some other less secure things
##

# set root password
sudo /usr/bin/mysqladmin -u root password 'password'

# allow remote access (required to access from our private network host. Note that this is completely insecure if used in any other way)
mysql -u root -ppassword -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION; FLUSH PRIVILEGES;"

# drop the anonymous users
mysql -u root -ppassword -e "DROP USER ''@'localhost';"
mysql -u root -ppassword -e "DROP USER ''@'$(hostname)';"

# drop the demo database
mysql -u root -ppassword -e "DROP DATABASE test;"

#
# add local mysql/mariadb config to change bind_address
# this fixes connecting through the port forwarded address on my machine
#
sudo cp /vagrant/my-vagrant.cnf /etc/mysql/conf.d/

# restart
sudo service mysql restart

# setup nginx php install confi
sudo cp /vagrant/nginx/php.conf /etc/nginx/sites-available/php.conf

# nginx enabled areas (can't recall it now)
sudo ln -s /etc/nginx/sites-available/php.conf /etc/nginx/sites-enabled/php.conf

# create php directory
sudo mkdir /usr/share/nginx/php
sudo chmod 755 /usr/share/nginx/php

echo '<html><head><title>PHP index</title></head><body>php index works for details: <a href="info.php">info.php</a></body></html> ' > /usr/share/nginx/php/index.php
echo '<?php phpinfo(); ?>' > /usr/share/nginx/php/info.php

# need to do a phpfm.ini config change
sudo service php5-fpm restart
sudo service nginx restart
