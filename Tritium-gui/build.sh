#!/bin/bash
set -e

NEXUS_GUI_VERSION=merging

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

docker build -t tritium-gui \
--build-arg UNAME=${UNAME} \
--build-arg DUID=${DUID} \
--build-arg DGID=${DGID} \
-f Dockerfile-tritium-gui-ubuntu-18.04 .
