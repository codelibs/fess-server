set JAVA_OPTS=%JAVA_OPTS% -Dsolr.solr.home="%CATALINA_HOME%\solr" -Dfess.log.file="%CATALINA_HOME%\webapps\fess\WEB-INF\logs\fess.out" -Dsolr.log.file="%CATALINA_HOME%\logs\solr.log" -Djava.awt.headless=true -server -Xmx1g -XX:+UseTLAB -XX:+DisableExplicitGC

for /f tokens^=2-5^ delims^=.-_^" %%j in ('java -fullversion 2^>^&1') do set "jver=%%j%%k"
if %jver% GTR "17" (~
set JAVA_OPTS=%JAVA_OPTS% -XX:MaxMetaspaceSize=128m -XX:+UseG1GC -XX:InitiatingHeapOccupancyPercent=45 -XX:MaxGCPauseMillis=200
 ) else (~
set JAVA_OPTS=%JAVA_OPTS% -XX:MaxPermSize=128m -XX:-UseGCOverheadLimit -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 -XX:+CMSIncrementalMode -XX:+CMSIncrementalPacing -XX:CMSIncrementalDutyCycleMin=0 -XX:+UseParNewGC -XX:+UseStringCache -XX:+UseCompressedOops
rem -XX:+UseCompressedStrings if java6u20 or above
rem -XX:+OptimizeStringConcat if java6u21 or above
 )
