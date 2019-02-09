#!/bin/bash

#bash tritium.sh stop

. ./settings.ini

find ${HOME}/${DOCK_DIR}/${NEXUS_VERSION}.TAO \
-mindepth 1 \
! -regex "${HOME}/${DOCK_DIR}/${NEXUS_VERSION}.TAO/LLL-TAO\(/.*\)?" \
! -regex "${HOME}/${DOCK_DIR}/${NEXUS_VERSION}.TAO/compiled_version.txt\(/.*\)?" \
-delete

# ! -regex "${HOME}/${DOCK_DIR}/${NEXUS_VERSION}.TAO/wallet.dat\(/.*\)?" \
#bash tritium.sh start
