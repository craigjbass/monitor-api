#!/bin/bash

set -e

if [ -z "$1" ]; then
  echo 'Provide an environment to deploy'
  exit 1
fi

ENVIRONMENT_NAME="$1"
APP_NAME="$1"

if [ "${ENVIRONMENT_NAME}" == "production" ]; then
  APP_NAME="${APP_NAME}-dark"
fi

curl -L "https://packages.cloudfoundry.org/stable?release=linux64-binary&source=github" | tar -zx
./cf api https://api.cloud.service.gov.uk
./cf auth "${CF_USER}" "${CF_PASSWORD}"

./cf target -o "${CF_ORG}" -s "${ENVIRONMENT_NAME}"

./cf push -f "deploy-manifests/${APP_NAME}.yml"
./cf set-env "monitor-api-${APP_NAME}" circle_commit "${CIRCLE_SHA1}"
./cf set-env "monitor-api-${APP_NAME}" SENTRY_DSN "${SENTRY_DSN}"
