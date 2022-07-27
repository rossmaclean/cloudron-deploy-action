#!/bin/bash

DOCKER_IMAGE=$1
APP_DOMAIN=$2
CLOUDRON_SERVER=$3
CLOUDRON_TOKEN=$4
INSTALL_IF_MISSING=$5

function installOrUpdate() {
  echo "cloudron list"
  echo $(cloudron list --server $CLOUDRON_SERVER --token $CLOUDRON_TOKEN)

  echo "cloudron list with grep"
  echo $(cloudron list --server $CLOUDRON_SERVER --token $CLOUDRON_TOKEN | grep $APP_DOMAIN)

  echo "cloudron list with grep and wc"
  echo $(cloudron list --server $CLOUDRON_SERVER --token $CLOUDRON_TOKEN | grep $APP_DOMAIN | wc -l)

  APP_EXISTS=$(cloudron list --server $CLOUDRON_SERVER --token $CLOUDRON_TOKEN | grep $APP_DOMAIN | wc -l)
  echo "APP_ALREADY_INSTALLED=$APP_EXISTS" >>$GITHUB_ENV

  if [ "$APP_EXISTS" = "0" ]; then
    if [ "$INSTALL_IF_MISSING" = "true" ]; then
      echo "App does not exist, installing"
      cloudron install --server $CLOUDRON_SERVER --token $CLOUDRON_TOKEN --location $APP_DOMAIN --image $DOCKER_IMAGE
    else
      echo "App does not exist, and install-if-missing is false, so doing nothing"
    fi
  else
    echo "App exists, updating"
    cloudron update --no-backup --server $CLOUDRON_SERVER --token $CLOUDRON_TOKEN --app $APP_DOMAIN --image $DOCKER_IMAGE
  fi
}

installOrUpdate
