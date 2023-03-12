#!/bin/bash

set -e


TEAMS_INSTANCE_NAME="${1}"

CHROMIUM_DATA="${HOME}/.config/ms-teams-in-chromium/${TEAMS_INSTANCE_NAME}"


# detect gpu devices to pass through
GPU_DEVICES=$( \
    echo "$( \
        find /dev -maxdepth 1 -regextype posix-extended -iregex '.+/nvidia([0-9]|ctl)' \
            | grep --color=never '.' \
          || echo '/dev/dri'\
      )" \
      | sed -E "s/^/--device /" \
  )

# get the xdg runtime dir
XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

# create the container
docker create \
  --name teams-${TEAMS_INSTANCE_NAME} \
  --cap-add SYS_ADMIN \
  --security-opt apparmor:unconfined \
  --net host \
  --device /dev/input \
  --device /dev/snd \
  --device /dev/video0 \
  $GPU_DEVICES \
  -v $HOME/Downloads:/downloads \
  -v ${CHROMIUM_DATA}:/data \
  -e PUID=$(id -u) \
  -e PGID=$(id -g) \
  -e DISPLAY=unix$DISPLAY \
  -e LANG=${LANG:-en_US.UTF-8} \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -v /dev/shm:/dev/shm \
  -v $HOME/.config/pulse:/home/ubuntu/.config/pulse:ro \
  -v /etc/machine-id:/etc/machine-id:ro \
  -v $XDG_RUNTIME_DIR/pulse:$XDG_RUNTIME_DIR/pulse:ro \
  -v $XDG_RUNTIME_DIR/bus:$XDG_RUNTIME_DIR/bus:ro \
  -v /var/lib/dbus/machine-id:/var/lib/dbus/machine-id:ro \
  -v /run/dbus:/run/dbus:ro \
  -v /run/udev/data:/run/udev/data:ro \
  -v /etc/localtime:/etc/localtime:ro \
  ms-teams 
