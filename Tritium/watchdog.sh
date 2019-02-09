#!/bin/bash
while : ;do
date +%y-%m-%d-%H:%M:%S
git pull
[[ "$(cat ~/.TAO/compiled_version.txt | grep ^commit | awk '{print $2}')" \
= "$(cd ~/.TAO/LLL-TAO/; git ls-remote origin -h refs/heads/merging | awk '{print $1}')" ]] || {
bash +x tritium.sh rebuild-code
bash +x tritium.sh stop
bash +x reset-data.sh
bash +x tritium.sh start
}
docker ps | grep nexus
[[ $? -ne 0 ]] && {
bash +x dump_uploader.sh
bash +x reset-data.sh
bash +x tritium.sh start
}
sleep 600
done

