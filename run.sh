#!/bin/sh
JAVA_OPTS="$JAVA_OPTS -Dbanproxy.username=$BANPROXY_USERNAME \
    -Dbanproxy.jdbc.url=$BANPROXY_JDBC_URL \
    -Dbanproxy.password=$BANPROXY_PASSWORD \
    -Dbanssuser.username=$BANSSUSER_USERNAME \
    -Dbanssuser.jdbc.url=$BANSSUSER_JDBC_URL \
    -Dbanssuser.password=$BANSSUSER_PASSWORD" \
catalina.sh run
