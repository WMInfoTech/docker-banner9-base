FROM tomcat:8-jre8-alpine

ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL

LABEL org.label-schema.vendor="Nix Team <unix@lists.wm.edu>" \
      org.label-schema.name="XE Tomcat JRE8" \
      org.label-schema.description="Base version of tomcat for Banner XE applications" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.schema-version="1.0"

# Configure Tomcat
ENV CATALINA_OPTS="-server -Xms2g -Xmx4g -XX:MaxPermSize=512m" \
    BANNER_INSTANCE="DEVL"

COPY config/* /usr/local/tomcat/conf/

ADD https://developer.byu.edu/maven2/content/groups/thirdparty/com/oracle/ojdbc6/11.2.0.1.0/ojdbc6-11.2.0.1.0.jar /usr/local/tomcat/lib/
ADD https://developer.byu.edu/maven2/content/groups/thirdparty/com/oracle/xdb6/11.2.0.4/xdb6-11.2.0.4.jar /usr/local/tomcat/lib/

RUN rm -Rf /usr/local/tomcat/webapps/* \
    && apk add --no-cache tzdata \
    && cp /usr/share/zoneinfo/America/New_York /etc/localtime

COPY run.sh /usr/local/tomcat/bin/

CMD ["/usr/local/tomcat/bin/run.sh"]
