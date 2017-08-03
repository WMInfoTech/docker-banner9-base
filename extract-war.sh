#!/bin/sh

cd /usr/local/tomcat/webapps

for war in /usr/local/tomcat/webapps/*.war; do
  mkdir $(basename "$war" .war)
  unzip -d $(basename "$war" .war) "$war"
  rm "$war"
done
