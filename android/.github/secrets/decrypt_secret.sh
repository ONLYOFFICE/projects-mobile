#!/bin/bash

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd $BASE_DIR

SECRETS=(
    "../../app/google-services.json"
    "../../google_api.json"
    "../../projects.properties"
    "../../projects.jks"
)

if [ -z "$GIT_ANDROID_PROJECTS_PASSPHRASE" ]
then
    echo "ERROR: Decrypt passphrase is not set"
    exit 1
fi

decrypt() {
    local file=$1
    echo "Create decrypt ${BASE_DIR}/$file"
    gpg --quiet --batch --yes --decrypt --passphrase="$GIT_ANDROID_PROJECTS_PASSPHRASE" --output "${BASE_DIR}/$file" "${BASE_DIR}/$file".gpg
}

for secret in ${SECRETS[@]}; do
    decrypt $secret
done