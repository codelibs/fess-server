#!/bin/sh

CONTEXT_NAME=fess

cd `dirname $0`
cd ..
TOMCAT_HOME=`pwd`
cd webapps/$CONTEXT_NAME
BASE_DIR=`pwd`

CP_PATH=WEB-INF/cmd/resources:WEB-INF/classes
# added WEB-INF/lib/*.jar
for cp_path in `ls WEB-INF/lib/*.jar` ; do
    CP_PATH="$CP_PATH:$cp_path"
done
# added WEB-INF/cmd/lib/*.jar
for cp_path in `ls WEB-INF/cmd/lib/*.jar` ; do
    CP_PATH="$CP_PATH:$cp_path"
done

SOLR_OPTS="$SOLR_OPTS -Dsolr.solr.home=$TOMCAT_HOME/solr -Dsolr.data.dir=$TOMCAT_HOME/solr/core1/data -Dfess.log.file=$BASE_DIR/WEB-INF/logs/fess_crawler.out"
FESS_OPTS="$FESS_OPTS -Dfess.crawler.process=true -Djava.awt.headless=true -server -XX:+UseGCOverheadLimit -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:+UseTLAB -Xmx512m -XX:MaxPermSize=128m"

java -cp $CP_PATH $SOLR_OPTS $FESS_OPTS jp.sf.fess.exec.Crawler $@
# args: --sessionId 20100518061741

