xhost +"local:docker@";
docker run --rm -it \
--name nexus-gui \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-e DISPLAY=unix$DISPLAY \
tritium-gui ;
xhost -"local:docker@"
