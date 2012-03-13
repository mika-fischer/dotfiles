#!/bin/bash

send_key() {
    for pid in $(pgrep spotify); do
        for win in $(xdotool search --pid $pid 2>/dev/null); do
            if xdotool getwindowname $win | grep -q "Linux Preview"; then
                # echo "Sending $@ to window $win"
                xdotool key --window $win "$@"
                return
            fi
        done
    done
    echo "Spotify is not running!"
    exit 1
}

playpause() {
    send_key space
}

prev() {
    send_key Control_L+Left
}

next() {
    send_key Control_L+Right
}

case $1 in
    play|pause|playpause)
        playpause
        ;;
    prev|previous)
        prev
        ;;
    next)
        next
        ;;
    *)
        echo "Invalid command: $1"
        exit 1
        ;;
esac

