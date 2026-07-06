#!/usr/bin/env bash
# sys_info.sh — Collects CPU/GPU temp, fan speed, and screen refresh rate for Waybar.

# CPU Temperature (k10temp)
CPU_TEMP="N/A"
for name_file in /sys/class/hwmon/hwmon*/name; do
    if [ -f "$name_file" ] && [ "$(cat "$name_file")" = "k10temp" ]; then
        DIR=$(dirname "$name_file")
        if [ -f "$DIR/temp1_input" ]; then
            CPU_TEMP=$(( $(cat "$DIR/temp1_input") / 1000 ))
        fi
        break
    fi
done

# GPU Temperature (Nvidia / AMD)
NVIDIA_TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null)
AMD_TEMP=""
for name_file in /sys/class/hwmon/hwmon*/name; do
    if [ -f "$name_file" ] && [ "$(cat "$name_file")" = "amdgpu" ]; then
        DIR=$(dirname "$name_file")
        if [ -f "$DIR/temp1_input" ]; then
            AMD_TEMP=$(( $(cat "$DIR/temp1_input") / 1000 ))
        fi
        break
    fi
done

GPU_TEMP="N/A"
GPU_SOURCE="N/A"
if [ -n "$NVIDIA_TEMP" ] && [ "$NVIDIA_TEMP" -eq "$NVIDIA_TEMP" ] 2>/dev/null; then
    GPU_TEMP="$NVIDIA_TEMP"
    GPU_SOURCE="Nvidia"
elif [ -n "$AMD_TEMP" ]; then
    GPU_TEMP="$AMD_TEMP"
    GPU_SOURCE="AMD"
fi

# Fan Speed (hp-wmi hwmon)
FAN1=0
FAN2=0
for name_file in /sys/class/hwmon/hwmon*/name; do
    if [ -f "$name_file" ] && [ "$(cat "$name_file")" = "hp" ]; then
        DIR=$(dirname "$name_file")
        FAN1=$(cat "$DIR/fan1_input" 2>/dev/null || echo 0)
        FAN2=$(cat "$DIR/fan2_input" 2>/dev/null || echo 0)
        break
    fi
done

# FPS (Active monitor refresh rate)
FPS=$(hyprctl monitors | grep -oP '\d+(?:\.\d+)?(?=\s+at)' | head -n 1 | cut -d. -f1)
FPS=${FPS:-60}

# Output format
TEXT=" ${CPU_TEMP}°C  󰢮 ${GPU_TEMP}°C  󰈐 ${FAN1} RPM  󰍹 ${FPS}Hz"
TOOLTIP="CPU: ${CPU_TEMP}°C\nGPU (${GPU_SOURCE}): ${GPU_TEMP}°C\nFan 1: ${FAN1} RPM\nFan 2: ${FAN2} RPM\nRefresh Rate: ${FPS}Hz"

echo "{\"text\": \"$TEXT\", \"tooltip\": \"$TOOLTIP\"}"
