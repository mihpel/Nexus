#!/bin/bash

#bash tritium.sh stop

find ${HOME}/.TAO \
-mindepth 1 \
! -regex "${HOME}/.TAO/LLL-TAO\(/.*\)?" \
! -regex "${HOME}/.TAO/compiled_version.txt\(/.*\)?" \
! -regex "${HOME}/.TAO/wallet.dat\(/.*\)?" \
-delete

#bash tritium.sh start
