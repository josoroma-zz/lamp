#!/bin/bash

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1

while [[ RET -ne 0 ]]; do
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done

mysql -uroot -e "CREATE USER '$2'@'%' IDENTIFIED BY '$3'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON $1.* TO '$2'@'%' WITH GRANT OPTION"

echo "=> mysql -u $2 -p$3 $1"

mysqladmin -uroot shutdown
