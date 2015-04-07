#!/bin/bash

# ------------------------------------------------------------------------------

# These file and folder permissions are manually executed to match
# the linked data directly to the local OS X file system.
# By: https://github.com/htmlgraphic

# Delete staff group.

groupdel staff

# Alter www-data group GID definition on the system.

groupmod -g 50 www-data

# Alter user nobody UID and shell.

usermod -s /bin/false -u 1000 nobody

# Apache should be able to write to the /tmp directory.

chown nobody:www-data /tmp

# ------------------------------------------------------------------------------

chmod -R 777 /var/www

chown -R nobody:www-data /var/www

# ------------------------------------------------------------------------------

# Change Apache user from www-data to nobody.

cp /etc/apache2/envvars /etc/apache2/envvars.ORIGINAL.`date +%F_%T | sed 's/[:-]/_/g'`

sed -i 's/APACHE_RUN_USER=www-data/APACHE_RUN_USER=nobody/g' /etc/apache2/envvars

# ------------------------------------------------------------------------------

# http://supervisord.org/running.html#running-supervisorctl

echo "=> Please restart the Apache Web Server using the command: supervisorctl"

echo "supervisor> restart httpd"

# ------------------------------------------------------------------------------
