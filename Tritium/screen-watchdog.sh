#!/bin/bash

duid=""

check_screen () {
[[ $(which screen) ]] || {
[[ $(id -u) -ne 0 ]] && duid=sudo
${duid} apt-get -qy update
${duid} apt-get -qy install screen
}
}

LCK="/tmp/$(basename $0).LCK";
exec 9>$LCK;
if ! flock -n 9 ; then
        echo " *** Tried to launch, but was canceled because there is another $(basename $0) running"
        exit 1
fi

check_screen
[[ $? -eq 0 ]] || exit 1


[[ -f .splitscreenrc ]] || {
cat <<-'EOF' > .splitscreenrc
layout new
screen 0
stuff "exec bash +x watchdog.sh\n"
title "nexus-watchdog - Ctrl\^a-tab:switch focus - Ctrl\^c:stop proccess - Ctrl\^a-d:detach"
sessionname nexus-watchdog
split -v
focus right
screen 1
title "docker-log-tail - Ctrl\^a-tab:switch focus - Ctrl\^c:stop proccess - Ctrl\^a-d:detach"
stuff "exec bash +x log-monitor-loop.sh\n"
focus left
detach
EOF
}

screen -c .splitscreenrc
screen -RD
