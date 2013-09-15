set JAVA_OPTS=%JAVA_OPTS% -Dsolr.solr.home="%CATALINA_HOME%\solr" -Dfess.solr.data.dir="%CATALINA_HOME%\solr\core1\data" -Dfess.log.file="%CATALINA_HOME%\webapps\fess\WEB-INF\logs\fess.out" -Djava.awt.headless=true -server -Xmx1g -XX:MaxPermSize=128m -XX:-UseGCOverheadLimit -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 -XX:+CMSIncrementalMode -XX:+CMSIncrementalPacing -XX:CMSIncrementalDutyCycleMin=0 -XX:+UseParNewGC -XX:+UseStringCache -XX:+UseTLAB -XX:+DisableExplicitGC
rem -XX:+UseCompressedOops
rem -XX:+UseCompressedStrings if java6u20 or above
rem -XX:+OptimizeStringConcat if java6u21 or above

