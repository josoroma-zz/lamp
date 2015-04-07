#!/bin/bash

/usr/bin/mysqld_safe > /dev/null 2>&1 &

echo "=> Creating Database $1."

RET=1

while [[ RET -ne 0 ]]; do
    sleep 5
    mysql -uroot -e "CREATE DATABASE $1 CHARACTER SET utf8 COLLATE 'utf8_general_ci'"
    RET=$?
done

mysqladmin -uroot shutdown
