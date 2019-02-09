#!/bin/bash
set -e

OAUTH_ACCESS_TOKEN="<Your dropbox API token goes here>"

uploaddate="$(date +%y-%m-%d)"
uploadtime="$(date +%H:%M:%S)"
dumpcommit="$(cat ~/.TAO/compiled_version.txt | grep ^commit | awk '{print $2}')"

[[ ! -f dropbox_uploader.sh ]] && {
wget https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh
}
[[ ! -f ${HOME}/.dropbox_uploader ]] && {
echo "OAUTH_ACCESS_TOKEN=${OAUTH_ACCESS_TOKEN}" > ${HOME}/.dropbox_uploader
}

for i in \
compiled_version.txt \
debug.log \
$(ls -1 ~/.TAO/ | grep ^core)
do \
[[ -f ~/.TAO/${i} ]] && {
bash dropbox_uploader.sh upload ~/.TAO/${i} dumps/${dumpcommit}/${uploaddate}-$(hostname)-${uploadtime}-${i}
rm ~/.TAO/${i}
}
done
