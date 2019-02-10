#!/bin/bash
commits=0
fails=0
loopcount=0
startdate="$(date --utc +%y-%m-%d-%H:%M:%S)"
ustartdate="$(date +'%s')"

. ./settings.ini

while : ;do
clear
set -e
[[ $(docker images -q --filter=reference='tritium-base*:*latest') ]] || bash +x tritium.sh build-base
[[ $(docker images -q --filter=reference='tritium-code*:*latest') ]] || bash +x tritium.sh build-code
set +e
(( loopcount +=1 ))
duration=$(($(date +'%s') - ${ustartdate}))
echo -e "\nCommit rebuilds since monitoring begun : ${commits}"
echo -e "fails since monitoring begun : ${fails}"
echo -e "commit : $(cat ~/${DOCK_DIR}/${NEXUS_VERSION}.TAO/compiled_version.txt | grep ^commit | awk '{print $2}')"
echo -e "\nloop: ${loopcount}\n"
echo -e "monitoring start: ${startdate}"
echo -e "current date: $(date --utc +%y-%m-%d-%H:%M:%S)"
echo -e "timelapse:${duration} Sec\n"
echo -e "$(tail ${HOME}/${DOCK_DIR}/${NEXUS_VERSION}.TAO/debug.log | grep height | tail -1 | tr ' ' '\n' | grep height)\n"
eval "echo $(date -ud "@${duration}" +'$((%s/3600/24)) Running: days %H hours %M minutes %S seconds')"
echo ""
git pull
[[ "$(cat ~/${DOCK_DIR}/${NEXUS_VERSION}.TAO/compiled_version.txt | grep ^commit | awk '{print $2}')" \
= "$(cd ~/${DOCK_DIR}/${NEXUS_VERSION}.TAO/LLL-TAO/; git ls-remote origin -h refs/heads/merging | awk '{print $1}')" ]] || {
bash +x tritium.sh rebuild-code
bash +x tritium.sh stop
bash +x reset-data.sh
[[ -d ~/${DOCK_DIR}/${NEXUS_VERSION}.TAO/LLL-TAO ]] && rm -rf ~/${DOCK_DIR}/${NEXUS_VERSION}.TAO/LLL-TAO
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

