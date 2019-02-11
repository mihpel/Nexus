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

[[ $(screen -ls | grep nexus-watchdog) ]] && {
        echo " *** A screen session named nexus-watchdog is already running"
	echo "reattach issuing : screen -RD $(screen -ls | grep nexus-watchdog | awk '{print $1}')"
	read -p "Reattach now (Yy) ? " -n 1 -r
	[[ $REPLY =~ ^[Yy]$ ]] && screen -RD $(screen -ls | grep nexus-watchdog | awk '{print $1}')
        exit 0
}

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

screen -S nexus-watcher -c .splitscreenrc
screen -RD
