#!/bin/bash

# ------------------------------------------------------------------------------

# Adding our custom Document Root folder.

echo "<?php phpinfo(); ?>" > /var/www/development/info.php

chmod -R 777 /var/www/development
chown -R www-data:www-data /var/www/development

# ------------------------------------------------------------------------------

# Adding Apache's mod_rewrite.

a2enmod rewrite

# ------------------------------------------------------------------------------

# Listen port.

mv -f /etc/apache2/ports.conf /etc/apache2/ports.conf.ORIGINAL

cp /docker/conf/ports.conf /etc/apache2/ports.conf

# ------------------------------------------------------------------------------

# Adding development virtual host.

mv -f /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.ORIGINAL

cp /docker/conf/000-default.conf /etc/apache2/sites-available/000-default.conf

# ------------------------------------------------------------------------------
