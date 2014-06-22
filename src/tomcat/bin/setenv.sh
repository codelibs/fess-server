#!/bin/sh

export JAVA_OPTS="$JAVA_OPTS -Dsolr.solr.home=$CATALINA_HOME/solr -Dfess.log.file=$CATALINA_HOME/webapps/fess/WEB-INF/logs/fess.out -Dsolr.log.file=$CATALINA_HOME/logs/solr.log -Djava.awt.headless=true -server -Xmx1g -XX:+UseTLAB -XX:+DisableExplicitGC"

JAVA_VER=$(java -version 2>&1 | grep version | sed 's/.*version "\(.*\)\.\(.*\)\..*"/\1\2/; 1q')
if [ "$JAVA_VER" -ge 18 ] ; then
  export JAVA_OPTS="$JAVA_OPTS -XX:MaxMetaspaceSize=128m -XX:CompressedClassSpaceSize=32m -XX:-UseGCOverheadLimit -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 -XX:+UseParNewGC -XX:+OptimizeStringConcat"
else
  export JAVA_OPTS="$JAVA_OPTS -XX:MaxPermSize=128m -XX:-UseGCOverheadLimit -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 -XX:+CMSIncrementalMode -XX:+CMSIncrementalPacing -XX:CMSIncrementalDutyCycleMin=0 -XX:+UseParNewGC -XX:+UseStringCache -XX:+UseCompressedStrings -XX:+OptimizeStringConcat -XX:+UseCompressedOops"
# if 32bit OS, remove -XX:+UseCompressedOops
# if Java heap size is over 32GB heap, remove -XX:+UseCompressedOops
# if your machine has 2 or more cpu, enabled -XX:+CMSParallelRemarkEnabled by -XX:+UseConcMarkSweepGC
fi

export CATALINA_OUT=/dev/null
