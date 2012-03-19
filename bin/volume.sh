#!/bin/bash

if pgrep -u $USER -x amixer >/dev/null; then
    exit 0
fi

if pgrep -u $USER -x pulseaudio >/dev/null; then
    inc=1000
else
    inc=2
fi

case $1 in
    up)
        amixer -q set Master ${inc}+
        ;;
    down)
        amixer -q set Master ${inc}-
        ;;
    mute)
        amixer -q set Master toggle
esac
