#!/bin/bash

playpause() {
    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
}

prev() {
    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous
}

next() {
    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next
}

case $1 in
    play|pause|playpause|toggle_play)
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

