#!/bin/bash

#bash tritium.sh stop

. ./settings.ini

find ${HOME}/${NEXUS_VERSION}.TAO \
-mindepth 1 \
! -regex "${HOME}/${NEXUS_VERSION}.TAO/LLL-TAO\(/.*\)?" \
! -regex "${HOME}/${NEXUS_VERSION}.TAO/compiled_version.txt\(/.*\)?" \
-delete

# ! -regex "${HOME}/${NEXUS_VERSION}.TAO/wallet.dat\(/.*\)?" \
#bash tritium.sh start
