-- -------------------
-- ---- AUTOSTART ----
-- -------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function ()
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
    hl.exec_cmd("nm-applet")
    -- awww: animated wallpaper daemon (replaces hyprpaper)
    hl.exec_cmd("awww init")
    hl.exec_cmd("sleep 0.5 && awww img ~/.config/hypr/wallpaper.jpg")
    -- eww: workspace-1 home widgets (clock/date)
    hl.exec_cmd("bash ~/.config/hypr/scripts/home-widgets.sh")
    hl.exec_cmd("hypridle")
end)
