#!/bin/bash
set -e

# Ensure that the plugins directories are created if we're mounting a fresh volume
mkdir -p extensions/jdbc-driver/oracle/ \
         extensions/deprecated \
         extensions/plugins

if [ ! -z "$SONARQUBE_JDBC_PASSWORD_PATH" ]; then
    SONARQUBE_JDBC_PASSWORD="$(cat "$SONARQUBE_JDBC_PASSWORD_PATH")"
    export SONARQUBE_JDBC_PASSWORD
fi

if [ "${1:0:1}" != '-' ]; then
  exec "$@"
fi

#${SONARQUBE_HOME}/bin/restore.sh

EXITCODE=0

java -jar "lib/sonar-application-$SONAR_VERSION.jar" \
  -Dsonar.log.console=true \
  -Dsonar.jdbc.username="$SONARQUBE_JDBC_USERNAME" \
  -Dsonar.jdbc.password="$SONARQUBE_JDBC_PASSWORD" \
  -Dsonar.jdbc.url="$SONARQUBE_JDBC_URL" \
  -Dsonar.web.javaAdditionalOpts="-Djava.security.egd=file:/dev/./urandom" \
  "$@"

# if [ ! java -jar "lib/sonar-application-$SONAR_VERSION.jar" \
#   -Dsonar.log.console=true \
#   -Dsonar.jdbc.username="$SONARQUBE_JDBC_USERNAME" \
#   -Dsonar.jdbc.password="$SONARQUBE_JDBC_PASSWORD" \
#   -Dsonar.jdbc.url="$SONARQUBE_JDBC_URL" \
#   -Dsonar.web.javaAdditionalOpts="-Djava.security.egd=file:/dev/./urandom" \
#   "$@" ] ; then
#     EXITCODE=$?
# fi

#${SONARQUBE_HOME}/bin/backup.sh

exit ${EXITCODE}
