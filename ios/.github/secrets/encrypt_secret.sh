#!/bin/bash

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd $BASE_DIR

SECRETS=(
    "../../Resources/GoogleService-Info-prod.plist"
    "../../Runner/Internal.plist"
)

if [ -z "$GIT_IOS_PROJECTS_PASSPHRASE" ]
then
    echo "ERROR: Decrypt passphrase is not set"
    exit 1
fi

encrypt() {
    local file=$1
    echo "Create encrypt ${BASE_DIR}/$file.gpg"
    gpg --quiet --batch --yes --symmetric --cipher-algo AES256 --passphrase="$GIT_IOS_PROJECTS_PASSPHRASE" --output "${BASE_DIR}/$file".gpg "${BASE_DIR}/$file"
}

for secret in ${SECRETS[@]}; do
    encrypt $secret
done