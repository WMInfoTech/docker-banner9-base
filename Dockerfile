FROM tomcat:8-jre7-alpine

# Configure Tomcat
ENV CATALINA_OPTS="-server -Xms2048m -Xmx4g -XX:MaxPermSize=512m"
COPY server.xml context.xml /usr/local/tomcat/conf/
ADD https://developer.byu.edu/maven2/content/groups/thirdparty/com/oracle/ojdbc6/11.2.0.1.0/ojdbc6-11.2.0.1.0.jar /usr/local/tomcat/lib/
ADD https://developer.byu.edu/maven2/content/groups/thirdparty/com/oracle/xdb6/11.2.0.4/xdb6-11.2.0.4.jar /usr/local/tomcat/lib/
RUN rm -Rf /usr/local/tomcat/webapps/*
COPY run.sh /usr/local/tomcat/bin/

ENV TIMEZONE=America/New_York \
    BANPROXY_INITIALSIZE=5 \
    BANPROXY_MAXACTIVE=100 \
    BANPROXY_MAXIDLE=-1 \
    BANPROXY_MAXWAIT=30000 \
    BANSSUSER_INITIALSIZE=5 \
    BANSSUSER_MAXACTIVE=100 \
    BANSSUSER_MAXIDLE=-1 \
    BANSSUSER_MAXWAIT=30000

ENV JAVA_OPTS -Duser.timezone=\$TIMEZONE \
  -Dbanproxy.initialsize=\$BANPROXY_INITIALSIZE \
  -Dbanproxy.maxactive=\$BANPROXY_MAXACTIVE \
  -Dbanproxy.maxidle=\$BANPROXY_MAXIDLE \
  -Dbanproxy.maxwait=\$BANPROXY_MAXWAIT \
  -Dbanssuser.initialsize=\$BANSSUSER_INITIALSIZE \
  -Dbanssuser.maxactive=\$BANSSUSER_MAXACTIVE \
  -Dbanssuser.maxidle=\$BANSSUSER_MAXIDLE \
  -Dbanssuser.maxwait=\$BANSSUSER_MAXACTIVE

CMD ["/usr/local/tomcat/bin/run.sh"]
