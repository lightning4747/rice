#!/usr/bin/env bash
# home-widgets.sh
# Starts eww daemon, opens home-widgets on workspace 1,
# then listens to Hyprland events to show/hide on ws switch.

EWW_WINDOW="home-widgets"

# Start daemon (no-op if already running)
eww daemon 2>/dev/null
sleep 0.5

# Show on ws1 at startup if we're already on it
CURRENT_WS=$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id')
[ "$CURRENT_WS" = "1" ] && eww open "$EWW_WINDOW" 2>/dev/null

# Listen for workspace change events via Hyprland socket
SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
socat -U - "UNIX-CONNECT:$SOCK" | while read -r line; do
    if [[ "$line" == workspace>>* ]]; then
        WS_ID="${line##*>>}"
        if [ "$WS_ID" = "1" ]; then
            eww open "$EWW_WINDOW" 2>/dev/null
        else
            eww close "$EWW_WINDOW" 2>/dev/null
        fi
    fi
done
