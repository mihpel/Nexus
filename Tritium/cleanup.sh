#!/bin/bash

. ./settings.ini

[[ -z $(docker ps | grep tritium-code) ]] || bash tritium.sh stop
[[ -d ~/${DOCK_DIR} ]] && rm -rf ~/${DOCK_DIR}
[[ -z $(docker images -q --filter=reference='tritium-code:*') ]] || docker rmi $(docker images -q --filter=reference='tritium-code:*')
[[ -z $(docker images -q --filter=reference='tritium-base:*') ]] || docker rmi $(docker images -q --filter=reference='tritium-base:*')
docker system prune
