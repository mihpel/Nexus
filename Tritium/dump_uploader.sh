#!/bin/bash
set -e

OAUTH_ACCESS_TOKEN="<Your dropbox API token goes here>"

uploadtime=$(date +%y-%m-%d-%H:%M:%S)

[[ ! -f dropbox_uploader.sh ]] && {
wget https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh
}
[[ ! -f ${HOME}/.dropbox_uploader ]] && {
echo "OAUTH_ACCESS_TOKEN=${OAUTH_ACCESS_TOKEN}" > ${HOME}/.dropbox_uploader
}

for i in \
compiled_version.txt \
debug.log \
$(ls -1 ~/.TAO/ | grep core)
do \
bash dropbox_uploader.sh upload ~/.TAO/${i} dumps/${uploadtime}-${i}
done
