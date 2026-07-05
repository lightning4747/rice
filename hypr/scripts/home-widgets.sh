#!/usr/bin/env bash
# home-widgets.sh
# Listens to Hyprland workspace events and shows/hides eww home-widgets
# on workspace 1. Run this from autostart.

EWW_WINDOW="home-widgets"
CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.id')

# Show on ws1 at startup
if [ "$CURRENT_WS" = "1" ]; then
    eww open "$EWW_WINDOW" 2>/dev/null
fi

# Listen for workspace change events
socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | \
while read -r line; do
    if [[ "$line" == workspace* ]]; then
        WS_ID="${line##*>>}"
        if [ "$WS_ID" = "1" ]; then
            eww open "$EWW_WINDOW" 2>/dev/null
        else
            eww close "$EWW_WINDOW" 2>/dev/null
        fi
    fi
done
