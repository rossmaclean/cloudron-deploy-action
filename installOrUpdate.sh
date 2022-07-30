#!/bin/bash

DOCKER_IMAGE=$1
APP_DOMAIN=$2
CLOUDRON_SERVER=$3
CLOUDRON_TOKEN=$4
INSTALL_IF_MISSING=$5
SKIP_BACKUP=$6
ENV_VARS=$7

function setEnvVars() {
  if [ -n "$ENV_VARS" ]; then
    echo "Setting environment variables"
    IFS=';'
    read -ra vars <<< "$ENV_VARS"
    for var in "${vars[@]}";
    do
     IFS='='
     read -ra keyval <<< "$var"
     echo "Setting var $keyval[0] to $keyval[1]"
    done
  fi
}

function installOrUpdate() {
#  APP_EXISTS=$(cloudron list --server $CLOUDRON_SERVER --token $CLOUDRON_TOKEN | grep $APP_DOMAIN | wc -l)
#  echo "APP_ALREADY_INSTALLED=$APP_EXISTS" >>$GITHUB_ENV
#
#  if [ "$APP_EXISTS" = "0" ]; then
#    if [ "$INSTALL_IF_MISSING" = "true" ]; then
#      echo "App does not exist, installing"
#      cloudron install --server $CLOUDRON_SERVER --token $CLOUDRON_TOKEN --location $APP_DOMAIN --image $DOCKER_IMAGE
#    else
#      echo "App does not exist, and install-if-missing is false, so doing nothing"
#    fi
#  else
#    echo "App exists, updating"
#    if [ "$SKIP_BACKUP" = "true" ]; then
#      echo "SKIP_BACKUP is true, skipping backup"
#      cloudron update --no-backup --server $CLOUDRON_SERVER --token $CLOUDRON_TOKEN --app $APP_DOMAIN --image $DOCKER_IMAGE
#    else
#      cloudron update --server $CLOUDRON_SERVER --token $CLOUDRON_TOKEN --app $APP_DOMAIN --image $DOCKER_IMAGE
#    fi
#  fi

  setEnvVars
}

installOrUpdate
