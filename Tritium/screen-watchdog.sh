#!/bin/bash

duid=""

check_screen () {
[[ $(which screen) ]] || {
[[ $(id -u) -ne 0 ]] && duid=sudo
${duid} apt-get -qy update
${duid} apt-get -qy install screen
}
}

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
