#!/bin/bash
commits=0
fails=0
loopcount=0

. ./settings.ini

while : ;do
set -e
[[ $(docker images -q --filter=reference='tritium-base*:*latest') ]] || bash +x tritium.sh build-base
[[ $(docker images -q --filter=reference='tritium-code*:*latest') ]] || bash +x tritium.sh build-code
set +e
(( loopcount +=1 ))
echo "rebuilds since mointoring begun : ${commits}"
echo "fails since mointoring begun : ${fails}"
echo -e "loop: ${loopcount} \n date: $(date --utc +%y-%m-%d-%H:%M:%S)\n"
git pull
[[ "$(cat ~/${NEXUS_VERSION}.TAO/compiled_version.txt | grep ^commit | awk '{print $2}')" \
= "$(cd ~/${NEXUS_VERSION}.TAO/LLL-TAO/; git ls-remote origin -h refs/heads/merging | awk '{print $1}')" ]] || {
bash +x tritium.sh rebuild-code
bash +x tritium.sh stop
bash +x reset-data.sh
[[ -d ~/${NEXUS_VERSION}.TAO/LLL-TAO ]] && rm -r ~/${NEXUS_VERSION}.TAO/LLL-TAO
bash +x tritium.sh start
(( commits +=1 ))
}
docker ps | grep nexus
[[ $? -ne 0 ]] && {
bash +x dump_uploader.sh
bash +x reset-data.sh
bash +x tritium.sh start
(( fails +=1 ))
}
sleep 600
done

