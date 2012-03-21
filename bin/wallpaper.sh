#!/bin/zsh

WALLPAPER_DIR="$HOME/share/wallpapers/used"
DELAY="15m"

if ! [ -d "$WALLPAPER_DIR" ]; then
    echo "Wallpaper dir does not exist!"
    exit 1
fi

if [ $(find -L $WALLPAPER_DIR -type f \( -name '*.jpg' -o -name '*.png' \) | wc -l) -eq 0 ]; then
    echo "Wallpaper dir is empty!"
    exit 1
fi

while true; do
    filename=$(find -L $WALLPAPER_DIR -type f \( -name '*.jpg' -o -name '*.png' \) -print0 | shuf -n1 -z | xargs -0 echo)
    feh --bg-fill "$filename"
    sleep $DELAY
done
