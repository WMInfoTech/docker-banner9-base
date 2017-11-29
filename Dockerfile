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
ENV CATALINA_OPTS="-server -Xms2g -Xmx4g -XX:MaxPermSize=512m"

COPY tomcat_config/* /usr/local/tomcat/conf/
COPY banner_config/* /banner_config/

ADD https://developer.byu.edu/maven2/content/groups/thirdparty/com/oracle/ojdbc6/11.2.0.1.0/ojdbc6-11.2.0.1.0.jar /usr/local/tomcat/lib/
ADD https://developer.byu.edu/maven2/content/groups/thirdparty/com/oracle/xdb6/11.2.0.4/xdb6-11.2.0.4.jar /usr/local/tomcat/lib/

COPY run.sh /usr/local/tomcat/bin/
COPY extract-war.sh /usr/local/bin/extract-war.sh

RUN apk add --no-cache xmlstarlet \
    && rm -Rf /usr/local/tomcat/webapps/* \
    && apk add --no-cache tzdata \
    && cp /usr/share/zoneinfo/America/New_York /etc/localtime \
    && addgroup -g 91 -S tomcat \
    && adduser -S -G tomcat -u 91 -h /usr/local/tomcat tomcat \
    && chown -R tomcat:tomcat /usr/local/tomcat /banner_config/

USER tomcat

CMD ["/usr/local/tomcat/bin/run.sh"]
