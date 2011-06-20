#!/bin/bash

NAME=$(basename $0)

PSC_BIN="pysqueezecenter"

if [ -z "$MYSQUEEZEBOXSERVER" ]; then
    echo "$NAME: Error: \$MYSQUEEZEBOXSERVER not defined!"
    exit 1
fi

if ! hash $PSC_BIN 2>&-; then
    echo "$NAME: Error: pysqueezecenter is not installed!"
    exit 1
fi

PLAYER=$(cat ~/.mysqueezebox 2>/dev/null)
if [ -z "$PLAYER" ]; then
    echo "$NAME: Error: Player not selected! Write MAC address of player to ~/.mysqueezebox"
    exit 1
fi

PSC="$PSC_BIN -s $MYSQUEEZEBOXSERVER -d $PLAYER -r -q"

case $1 in
    toggle_play)
        if [[ $($PSC get_mode) == "play" ]]; then
            exec $PSC pause
        else
            exec $PSC play
        fi
        ;;
    *)
        exec $PSC "$@"
        ;;
esac

