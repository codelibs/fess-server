#!/bin/bash

CONFIG_FILE=$1
cd `dirname $0`
BASE_DIR=`pwd`

if [ x$CONFIG_FILE != "x" -a -f "$CONFIG_FILE" ] ; then
    . $CONFIG_FILE
else
    echo -n "MySQL(root) Password: "
    read -s MYSQL_PASSWORD
    echo
fi

DROP_SQL_FILE=/tmp/fess_db.sql.$$
echo "drop database fess_db;" >> $DROP_SQL_FILE
echo "drop database fess_robot;" >> $DROP_SQL_FILE
echo "FLUSH PRIVILEGES;" >> $DROP_SQL_FILE
echo -n "Dropping DB on MySQL..."
mysql -u root --password=$MYSQL_PASSWORD < $DROP_SQL_FILE
ret=`echo $?`
if [ $ret == 0 ] ; then 
    echo "Dropped."
fi
rm $DROP_SQL_FILE

