#!/usr/bin/env bash
# fan_control.sh — Adjusts fan speed and sends a notification.
# Uses flock to prevent async race conditions when keys are held down.

PWM_PATH=$(glob() { echo "$1"; }; glob /sys/devices/platform/hp-wmi/hwmon/hwmon*/pwm1)
ENABLE_PATH=$(glob() { echo "$1"; }; glob /sys/devices/platform/hp-wmi/hwmon/hwmon*/pwm1_enable)

if [ ! -f "$PWM_PATH" ]; then
    notify-send -t 2000 "Fan Control" "Error: Fan control device not found!"
    exit 1
fi

LOCK_FILE="/tmp/fan_control.lock"

# Execute all read-write operations inside a serialized lock
(
    flock -x 200

    CURRENT_VAL=$(cat "$PWM_PATH" 2>/dev/null)
    CURRENT_VAL=${CURRENT_VAL:-0}
    STEP=26

    case "$1" in
        up)
            NEW_VAL=$((CURRENT_VAL + STEP))
            [ $NEW_VAL -gt 255 ] && NEW_VAL=255
            ;;
        down)
            NEW_VAL=$((CURRENT_VAL - STEP))
            [ $NEW_VAL -lt 0 ] && NEW_VAL=0
            ;;
        max)
            NEW_VAL=255
            ;;
        off)
            NEW_VAL=0
            ;;
        *)
            if [[ "$1" =~ ^[0-9]+$ ]] && [ "$1" -ge 0 ] && [ "$1" -le 255 ]; then
                NEW_VAL="$1"
            else
                echo "Usage: $0 {up|down|max|off|value}"
                exit 1
            fi
            ;;
    esac

    # Ensure manual fan control is enabled
    if [ -f "$ENABLE_PATH" ]; then
        echo "1" > "$ENABLE_PATH" 2>/dev/null
    fi

    # Write the new value
    echo "$NEW_VAL" > "$PWM_PATH" 2>/dev/null

    # Calculate percentage
    PCT=$(( NEW_VAL * 100 / 255 ))

    # Run notify-send in background (&) to prevent blocking the lock release
    if [ $? -eq 0 ]; then
        notify-send -r 9991 -t 1500 -i kcmthermal "Fan Control" "Speed: ${PCT}% (${NEW_VAL}/255)" &
    else
        # Fallback to sudo if permission is not set up yet
        sudo sh -c "echo $NEW_VAL > $PWM_PATH"
        notify-send -r 9991 -t 1500 -i kcmthermal "Fan Control" "Speed: ${PCT}% (${NEW_VAL}/255) [sudo]" &
    fi

) 200>"$LOCK_FILE"
