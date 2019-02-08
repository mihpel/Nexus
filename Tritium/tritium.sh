#/bin/bash

set -e

NEXUS_VERSION=merging
ENABLE_DEBUG=1


[[ $(id -u) -eq 0 ]] && {
UNAME=nexus
DUID=1342
DGID=1342
}

[[ $(id -u) -ne 0 ]] && {
UNAME=$(id -un)
DUID=$(id -u)
DGID=$(id -g)
}

[[ -d ${HOME}/.TAO ]] || {
mkdir ${HOME}/.TAO
}
set +e
chown -R ${DUID}:${DGID} ${HOME}/.TAO
[[ $? -ne 0 ]] && {
echo -e "\nYou should make sure that the your user: $(id -un) has sufficient rights \n\
to be able to set the appropriate rights for user: ${UNAME} with uid: ${GUID} and \n\
gid: ${DGID} on the created direcory: ${HOME}/.TAO \n\
"
exit 1
}
set -e
echo -e "\nInitial settings:\n\
\n  UserNAME = ${UNAME}\n\
  user uid = ${DUID}\n\
  user gid = ${DGID}\n\
  nexus build version = ${NEXUS_VERSION}\n\
  enable_debug = ${ENABLE_DEBUG}
\n\
Edit in file to alter the above\n\
"
options () {
echo -e "\nunrecognised option\n"
echo -e "options: <build-base> <rebuild-base> <build-code> <rebuild-code> <start> <restart> <stop>\n"
echo -e "a single option allowed at a time\n"
exit 1
}
[[ -z "$@" || ! -z $2 ]] && options
[[ "$1" = "rebuild-base" ||\
 "$1" = "build-base" ||\
 "$1" = "rebuild-code" ||\
 "$1" = "build-code" ||\
 "$1" = "start" ||\
 "$1" = "restart" ||\
 "$1" = "stop" ]] || {
options
}
[[ "$1" = "rebuild-base" ]] && {
docker build \
-t tritium-base \
--no-cache \
--pull \
-f Dockerfile-tritium-base-ubuntu-18.04 .
}
[[ "$1" = "build-base" ]] && {
docker build \
-t tritium-base \
-f Dockerfile-tritium-base-ubuntu-18.04 .
}
[[ "$1" = "rebuild-code" ]] && {
docker build \
-t tritium-code \
--no-cache \
--build-arg NEXUS_VERSION=${NEXUS_VERSION} \
--build-arg UNAME=${UNAME} \
--build-arg DUID=${DUID} \
--build-arg DGID=${DGID} \
--build-arg ENABLE_DEBUG=${ENABLE_DEBUG} \
-f Dockerfile-tritium-code-ubuntu-18.04 .
}
[[ "$1" = "build-code" ]] && {
docker build \
-t tritium-code \
--build-arg NEXUS_VERSION=${NEXUS_VERSION} \
--build-arg UNAME=${UNAME} \
--build-arg DUID=${DUID} \
--build-arg DGID=${DGID} \
--build-arg ENABLE_DEBUG=${ENABLE_DEBUG} \
-f Dockerfile-tritium-code-ubuntu-18.04 .
}
[[ "$1" = "start" ]] && {
	[[ -f ${HOME}/.TAO/docker-start.sh ]] || {
	docker run --rm -it -v ${HOME}/.TAO/:/tmp/ tritium su ${UNAME} -c 'cp /usr/local/bin/start /tmp/docker-start.sh'
	}
docker run \
--rm \
-itd \
--ulimit core=9999999999 \
--name nexus \
--privileged \
-p 0.0.0.0:9323:9323 \
-v ${HOME}/.TAO/:/home/${UNAME}/.TAO:rw \
-v ${HOME}/.TAO/docker-start.sh:/usr/local/bin/start:rw \
tritium-code
}
[[ "$1" = "restart" ]] && {
docker restart nexus
}
[[ "$1" = "stop" ]] && {
docker stop nexus
}
exit 0
