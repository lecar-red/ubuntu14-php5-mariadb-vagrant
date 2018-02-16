#!/bin/bash

#
# i'm not clear on how to best handle errors from inside the bootstrap file
#

#
# Install packages
#
sudo apt-get install software-properties-common
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu trusty main'

sudo apt-get update
sudo apt-get install mariadb-server

# install nginx
sudo apt-get -y install nginx

# install php5 and tools
sudo apt-get -y install php5 php5-fpm php5-mysql


# ensure it is running
sudo /etc/init.d/mysql restart

# set to auto start (not yet a native service so use old style)
sudo chkconfig mysql on

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
# TODO: add comment out of bind_address in /etc/mysql/my.cnf
#       which seems to cause issues with ssh tunnels in mariadb 10.1 (not sure about others)
#

# restart
sudo /etc/init.d/mysql restart

# setup nginx php install confi
sudo cp /vagrant/nginx/php.conf /etc/nginx/sites-available/php.conf

#
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