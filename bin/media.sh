#!/bin/bash

if pgrep -u $USER -x spotify >/dev/null; then
    exec $HOME/bin/spotify.sh "$@"
else
    echo $HOME/bin/squeezebox.sh "$@"
fi
