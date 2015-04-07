#!/bin/bash

# ------------------------------------------------------------------------------

# Delete staff group.

groupdel staff

# Set the apache user and group to match the host user.

OWNER=$(stat -c '%u' /var/www)
GROUP=$(stat -c '%g' /var/www)

echo "=> Development owner and group => $OWNER:$GROUP"

usermod -o -u $OWNER www-data
groupmod -o -g $GROUP www-data

chmod -R 777 /var/www
chown -R www-data:www-data /var/www

# ------------------------------------------------------------------------------
