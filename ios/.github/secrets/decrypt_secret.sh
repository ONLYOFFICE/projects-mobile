#!/bin/bash

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd $BASE_DIR

SECRETS=(
    "../../Resources/GoogleService-Info-prod.plist"
    "../../Runner/Internal.plist"
)

if [ -z "$GIT_IOS_PROJECTS_PASSPHRASE" ]
then
    echo "ERROR: Decrypt passphrase is not set" >&2
    exit 1
fi

decrypt() {
    local file=$1
    echo "Create decrypt ${BASE_DIR}/$file"
    gpg --quiet --batch --yes --decrypt --passphrase="$GIT_IOS_PROJECTS_PASSPHRASE" --output "${BASE_DIR}/$file" "${BASE_DIR}/$file".gpg
}

for secret in ${SECRETS[@]}; do
    decrypt $secret
done