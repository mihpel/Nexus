#/bin/bash

set -e

NEXUS_VERSION=merging
ENABLE_DEBUG=1

UNAME=$(id -un)
DUID=$(id -u)
DGID=$(id -g)

[[ -d ${HOME}/.TAO ]] || {
mkdir ${HOME}/.TAO
}

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
echo -e "options: <build> <rebuild <start> <restart> <stop>\n"
echo -e "a single option allowed at a time\n"
exit 1
}
[[ -z "$@" || ! -z $2 ]] && options
[[ "$1" = "rebuild" ||\
 "$1" = "build" ||\
 "$1" = "start" ||\
 "$1" = "restart" ||\
 "$1" = "stop" ]] || {
options
}
[[ "$1" = "rebuild" ]] && {
docker build \
-t tritium \
--no-cache \
--pull \
--build-arg NEXUS_VERSION=${NEXUS_VERSION} \
--build-arg UNAME=${UNAME} \
--build-arg DUID=${DUID} \
--build-arg DGID=${DGID} \
--build-arg ENABLE_DEBUG=${ENABLE_DEBUG} \
-f Dockerfile-tritium-ubuntu-18.04 .
}
[[ "$1" = "build" ]] && {
docker build \
-t tritium \
--build-arg NEXUS_VERSION=${NEXUS_VERSION} \
--build-arg UNAME=${UNAME} \
--build-arg DUID=${DUID} \
--build-arg DGID=${DGID} \
--build-arg ENABLE_DEBUG=${ENABLE_DEBUG} \
-f Dockerfile-tritium-ubuntu-18.04 .
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
tritium
}
[[ "$1" = "restart" ]] && {
docker restart ${UNAME}
}
[[ "$1" = "stop" ]] && {
docker stop ${UNAME}
}
exit 0
