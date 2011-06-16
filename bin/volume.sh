#!/bin/bash

if pgrep -x amixer >/dev/null; then
    exit 0
fi

case $1 in
    up)
        amixer -q set Master 2+
        ;;
    down)
        amixer -q set Master 2-
        ;;
    mute)
        amixer -q set Master toggle
esac
