#!/usr/bin/env bash

# File path passed by waypaper
WALLPAPER="$1"

# Get current backend from config.ini
CONFIG_FILE="$HOME/.config/waypaper/config.ini"
if [ ! -f "$CONFIG_FILE" ]; then
    exit 0
fi

BACKEND=$(grep -E "^backend\s*=" "$CONFIG_FILE" | cut -d'=' -f2 | tr -d '[:space:]')

if [ "$BACKEND" = "mpvpaper" ]; then
    # Kill other daemons
    pkill -f awww-daemon
    pkill -x hyprpaper

    # Detect if it's a video file and check resolution
    if [ -f "$WALLPAPER" ]; then
        # Check dimensions using ffprobe
        DIMENSIONS=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$WALLPAPER" 2>/dev/null)
        if [ ! -z "$DIMENSIONS" ]; then
            WIDTH=$(echo "$DIMENSIONS" | cut -d'x' -f1)
            HEIGHT=$(echo "$DIMENSIONS" | cut -d'x' -f2)
            
            ROTATION_ARG=""
            if [ -n "$WIDTH" ] && [ -n "$HEIGHT" ] && [ "$WIDTH" -lt "$HEIGHT" ]; then
                # Video is vertical, rotate it 90 degrees to make it horizontal (16:9)
                ROTATION_ARG="--video-rotate=90"
            fi
            
            # Restart mpvpaper with the proper rotation and loop settings
            pkill -x mpvpaper
            mpvpaper -o "no-audio --loop-file=inf $ROTATION_ARG" "*" "$WALLPAPER" &
        fi
    fi
elif [ "$BACKEND" = "awww" ]; then
    # Kill mpvpaper so the static wallpaper is shown
    pkill -x mpvpaper
    pkill -x hyprpaper
    # Make sure awww-daemon is running
    if ! pgrep -f awww-daemon >/dev/null; then
        awww-daemon &
        sleep 0.3
        # Send the image to the newly started daemon
        awww img "$WALLPAPER"
    fi
elif [ "$BACKEND" = "hyprpaper" ]; then
    # Kill other daemons
    pkill -f awww-daemon
    pkill -x mpvpaper
    # Ensure hyprpaper is running
    if ! pgrep -x hyprpaper >/dev/null; then
        hyprpaper &
        sleep 0.3
    fi
fi
