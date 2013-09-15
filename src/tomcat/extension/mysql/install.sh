#!/bin/bash

CONFIG_FILE=$1
cd `dirname $0`
BASE_DIR=`pwd`

PRODUCT_NAME=fess

if [ x$CONFIG_FILE != "x" -a -f "$CONFIG_FILE" ] ; then
    . $CONFIG_FILE
else
    echo -n "Please enter a new DB password(search server)> "
    read -s FESS_PASSWORD
    echo

    echo -n "Please enter a new DB password(crawler)> "
    read -s ROBOT_PASSWORD
    echo

    echo -n "MySQL(root) Password: "
    read -s MYSQL_PASSWORD
    echo
fi

CREATE_SQL_FILE=/tmp/fess_db.sql.$$
echo "create database fess_db;" >> $CREATE_SQL_FILE
echo "GRANT ALL PRIVILEGES ON fess_db.* TO fess_user@localhost IDENTIFIED BY '$FESS_PASSWORD';" >> $CREATE_SQL_FILE
echo "create database fess_robot;" >> $CREATE_SQL_FILE
echo "GRANT ALL PRIVILEGES ON fess_robot.* TO s2robot@localhost IDENTIFIED BY '$ROBOT_PASSWORD';" >> $CREATE_SQL_FILE
echo "FLUSH PRIVILEGES;" >> $CREATE_SQL_FILE
echo -n "Creating DB on MySQL..."
mysql -u root --password=$MYSQL_PASSWORD < $CREATE_SQL_FILE
ret=`echo $?`
if [ $ret == 0 ] ; then 
    echo "Created."
fi
rm $CREATE_SQL_FILE

echo -n "Creating tables..."
mysql -u fess_user --password=$FESS_PASSWORD fess_db < $BASE_DIR/fess.ddl
ret1=`echo $?`
mysql -u s2robot --password=$ROBOT_PASSWORD fess_robot < $BASE_DIR/robot.ddl
ret2=`echo $?`
if [ $ret1 == 0 -a $ret2 == 0 ] ; then 
    echo " Created."
fi

cd ../..

TMP_FILE=/tmp/fess_dicon.$$
sed -e "s/password\">[^<]*</password\">\"$FESS_PASSWORD\"</" \
    ./webapps/$PRODUCT_NAME/WEB-INF/classes/jdbc.dicon > $TMP_FILE
cp $TMP_FILE ./webapps/$PRODUCT_NAME/WEB-INF/classes/jdbc.dicon
sed -e "s/password\">[^<]*</password\">\"$ROBOT_PASSWORD\"</" \
    ./webapps/$PRODUCT_NAME/WEB-INF/classes/s2robot_jdbc.dicon > $TMP_FILE
cp $TMP_FILE ./webapps/$PRODUCT_NAME/WEB-INF/classes/s2robot_jdbc.dicon
rm $TMP_FILE

