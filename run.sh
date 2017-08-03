#!/bin/sh
# shellcheck disable=SC2013,SC2046

PROPFILE="/usr/local/tomcat/conf/catalina.properties"
if [ ! -f "$PROPFILE" ]; then
  echo "Unable to find properties file $PROPFILE"
  exit 1
fi

setProperty() {
  prop=$1
  val=$2

  if [ "$prop" = "cas.serverName" ]; then
    for settings_file in /usr/local/tomcat/webapps/*/WEB-INF/web.xml; do
      xml ed  --inplace -N x="http://java.sun.com/xml/ns/javaee" -u "/x:web-app/x:filter[x:filter-name[normalize-space(text())='CAS Validation Filter']]/x:init-param[x:param-name[normalize-space(text())='serverName']]/x:param-value" -v "$val" "$settings_file"
    done
  fi

  if [ "$prop" = "cas.casServerUrlPrefix" ]; then
    for settings_file in /usr/local/tomcat/webapps/*/WEB-INF/web.xml; do
      xml ed  --inplace -N x="http://java.sun.com/xml/ns/javaee" -u "/x:web-app/x:filter[x:filter-name[normalize-space(text())='CAS Validation Filter']]/x:init-param[x:param-name[normalize-space(text())='casServerUrlPrefix']]/x:param-value" -v "$val" "$settings_file"
    done
  fi

  if [ $(grep -c "$prop" "$PROPFILE") -eq 0 ]; then
    echo "${prop}=$val" >> "$PROPFILE"
  else
    val=$(echo "$val" |sed 's#/#\\/#g')
    sed -i "s/$prop=.*/$prop=$val/" "$PROPFILE"
  fi
}

setPropsFromFile() {
  file=$1
  for l in $(grep '=' "$file" | grep -v '^ *#'); do
    prop=$(echo "$l" |cut -d= -f1)
    val=$(echo "$l" |cut -d= -f2)
    setProperty "$prop" "$val"
  done
}

if [ -z "$CONFIG_FILE" ] && [ -f "$CONFIG_FILE" ]; then
    setPropsFromFile "$CONFIG_FILE"
fi

# Pull properties from docker secrets
if [ -d /run/secrets ]; then
  for file in /run/secrets/*; do
    prop=$(basename "$file")
    val=$(cat "$file")
    setProperty "$prop" "$val"
  done
fi

setProperty bannerdb.url "$BANNERDB_URL"
setProperty banproxy.username "$BANNERDB_USER"
setProperty banproxy.password "$BANNERDB_PASSWORD"
setProperty banssuser.username "$BANNERSSDB_USER"
setProperty banssuser.password "$BANNERSSDB_PASSWORD"
setProperty cas.serverName "$APP_URL"

exec catalina.sh run
