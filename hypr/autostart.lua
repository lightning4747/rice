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
    -- Custom draggable clock widget on workspace 1
    hl.exec_cmd("python ~/.config/hypr/scripts/home_clock.py")
    hl.exec_cmd("hypridle")
end)
