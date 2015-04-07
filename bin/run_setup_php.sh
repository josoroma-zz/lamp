#!/bin/bash

# ------------------------------------------------------------------------------

# Adding php5 xdebug.ini files.

cp /docker/conf/xdebug.ini /etc/php5/mods-available/xdebug.ini

rm -f /etc/php5/apache2/conf.d/20-xdebug.ini /etc/php5/cli/conf.d/20-xdebug.ini

ln -s /etc/php5/mods-available/xdebug.ini /etc/php5/apache2/conf.d/20-xdebug.ini
ln -s /etc/php5/mods-available/xdebug.ini /etc/php5/cli/conf.d/20-xdebug.ini

# ------------------------------------------------------------------------------

cp /etc/php5/apache2/php.ini /etc/php5/apache2/php.ini.ORIGINAL

sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/apache2/php.ini

cp /etc/php5/cli/php.ini /etc/php5/cli/php.ini.ORIGINAL

sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/cli/php.ini

# ------------------------------------------------------------------------------

# Adding mcrypt php module.

php5enmod mcrypt

# ------------------------------------------------------------------------------
