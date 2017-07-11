#!/bin/sh
# shellcheck disable=SC2013,SC2046

if [ -z "$BANNER_INSTANCE" ]; then
  echo 'ERROR: BANNER_INSTANCE must be set'
  exit 1
fi

PROPFILE="/usr/local/tomcat/conf/catalina.properties"
if [ ! -f "$PROPFILE" ]; then
  echo "Unable to find properties file $PROPFILE"
  exit 1
fi

setProperty() {
  prop=$1
  val=$2

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

setPropFromEnv() {
  prop=$1
  val=$2
  # If no value was given, abort
  [ -z "$val" ] && return
  if [ $(grep -c "$prop" "$PROPFILE") -eq 0 ]; then
    echo "${prop}=$val" >> "$PROPFILE"
  else
    val=$(echo "$val" |sed 's#/#\\/#g')
    sed -i "s/$prop=.*/$prop=$val/" "$PROPFILE"
  fi
}

if [ -f "/opt/instance-config/${BANNER_INSTANCE}.properties" ]; then
  setPropsFromFile /opt/instance-config/${BANNER_INSTANCE}.properties
fi


# Pull properties from docker secrets
if [ -d /run/secrets ]; then
  for file in /run/secrets/*; do
    prop=$(basename "$file")
    val=$(cat "$file")
    setProperty "$prop" "$val"
  done
fi

setPropFromEnv bannerdb.url "$BANNERDB_URL"
setPropFromEnv banproxy.username "$BANNERDB_USER"
setPropFromEnv banproxy.password "$BANNERDB_PASSWORD"
setPropFromEnv banssuser.username "$BANNERSSDB_USER"
setPropFromEnv banssuser.password "$BANNERSSDB_PASSWORD"
setPropFromEnv BANNER_APP_CONFIG "/usr/local/tomcat/conf/banner_configuration.groovy"

exec catalina.sh run
