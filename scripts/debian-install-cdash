#!/bin/bash

xpl_path=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

cd /opt

# extract git repo
if [ ! -d cdash ]
then
	git clone https://github.com/Kitware/CDash.git cdash
else
	cd cdash
	git fetch
	git pull
	cd -
fi

cd cdash
git checkout release
cd -

#see http://public.kitware.com/Wiki/CDash:Installation
#sudo apt-get install apache2 mysql-server php5 php5-mysql php5-xsl php5-curl php5-gd
	
# add apache vhost for cdash
#cp ${xpl_path}/cdash.conf /etc/apache2/sites-available
#a2ensite cdash
#a2enmod rewrite
#service apache2 reload