#!/bin/bash

ulimit -u 10240 -n 65535

export LANG="en_US.UTF-8"
export JAVA_HOME="/opt/jdk7"

TOMCAT_BASE="/data/tomcat$1"
PROJECT_NAME=`sed -n 's/.*docBase="\/data\/www\/\(.*\)".*/\1/p' $TOMCAT_BASE/conf/server.xml`

export LOGGING_CONFIG="-D______tomcat$1=$PROJECT_NAME -Djava.util.logging.config.file=$TOMCAT_BASE/conf/logging.properties"
export CATALINA_OPTS="-Xms218m -Xmx2048m -Djava.awt.headless=true -verbose:gc"

case "$2" in
        start)
                $TOMCAT_BASE/bin/startup.sh
        ;;
        stop)
                ps -eo pid,cmd |grep -v tail |grep -v grep |grep $TOMCAT_BASE |awk '{print $1}' |xargs kill -9 
                rm -rf $TOMCAT_BASE/work/*
        ;;
        restart)
                $0 $1 stop
                $0 $1 start
        ;;
        out)
                tail -f -n1000 $TOMCAT_BASE/logs/catalina.out
        ;;
        *)
                echo "Usage: $0 n [start|stop|restart]"
        ;;
esac
