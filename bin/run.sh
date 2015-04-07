#!/bin/bash

# ------------------------------------------------------------------------------

VOLUME_HOME="/var/lib/mysql"

if [[ ! -d $VOLUME_HOME/mysql ]]; then

    echo '=> Creating development and staging databases.'

    mysql_install_db > /dev/null 2>&1

    /docker/bin/run_setup_mysql_create_db.sh db$MYSQL_DEVELOPMENT_TAG
    /docker/bin/run_setup_mysql_create_db_user.sh db$MYSQL_DEVELOPMENT_TAG usr$MYSQL_DEVELOPMENT_TAG pass$MYSQL_DEVELOPMENT_TAG

    /docker/bin/run_setup_mysql_create_db.sh db$MYSQL_STAGING_TAG
    /docker/bin/run_setup_mysql_create_db_user.sh db$MYSQL_STAGING_TAG usr$MYSQL_STAGING_TAG pass$MYSQL_STAGING_TAG

else

    echo '=> Using a pre-existing database.'

fi

# ------------------------------------------------------------------------------

# Running the supervisord daemon.

echo "=> Starting supervisord"

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf -n

# ------------------------------------------------------------------------------

echo '=> Happy Hacking!'

# ------------------------------------------------------------------------------
