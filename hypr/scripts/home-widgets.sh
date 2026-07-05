#!/usr/bin/env bash
# home-widgets.sh — Shows eww clock widget ONLY on workspace 1
# Polls every 200ms (lightweight — ~0% CPU)

EWW_WINDOW="home-widgets"

# Start daemon if not running
eww daemon 2>/dev/null
sleep 0.8

LAST_WS=""

while true; do
    WS=$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id' 2>/dev/null)
    if [ "$WS" != "$LAST_WS" ]; then
        if [ "$WS" = "1" ]; then
            eww open "$EWW_WINDOW" 2>/dev/null
        else
            eww close "$EWW_WINDOW" 2>/dev/null
        fi
        LAST_WS="$WS"
    fi
    sleep 0.2
done
