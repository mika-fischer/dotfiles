#!/bin/bash

CURFILE="$HOME/.mysqueezebox"
SB="$HOME/bin/squeezebox.sh"

current=$(cat $CURFILE 2>/dev/null)

if [ -z "$MYSQUEEZEBOXSERVER" ]; then
    echo "$NAME: Error: \$MYSQUEEZEBOXSERVER not defined!"
    exit 1
fi

if ! [ -x $SB ]; then
    echo "$NAME: Error: squeezebox.sh is not installed!"
    exit 1
fi

macs=()
names=()

OIFS="$IFS"
IFS=""
OUTPUT=$($SB -i 2>&1 | grep Player)
IFS="
"

for line in $OUTPUT; do
    mac=$(echo $line | sed 's/^INFO: Player: \([^ ]\+\).*/\1/')
    name=$(echo $line | sed 's/^[^|]\+ | \([^|]\+\) |.*/\1/')
    macs=("${macs[@]}" "$mac")
    names=("${names[@]}" "$name")
done

selected=$(for i in $(seq 0 $(( ${#names[@]} - 1 ))); do
    if [[ -n $current ]] && [[ "${macs[$i]}" =~ "$current" ]]; then
        echo -ne "TRUE\n"
    else
        echo -ne "FALSE\n"
    fi
    echo -ne "${names[$i]}\n${macs[$i]}\n"
done | zenity --title "Select Squeezebox" --width 400 --height 300 --list --text "Select Squeezebox" --radiolist --column "" --column "Player" --column "MAC address")

newmac=$(for i in $(seq 0 $(( ${#names[@]} - 1 ))); do
    if [[ -n $selected ]] && [[ "${names[$i]}" =~ "$selected" ]]; then
        echo -ne "${macs[$i]}\n"
    fi
done)

if [ -n $newmac ]; then
    echo $newmac > $CURFILE
fi

