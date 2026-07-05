-- -------------------
-- ---- AUTOSTART ----
-- -------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function ()
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("bash ~/.config/hypr/scripts/home-widgets.sh")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("sleep 0.5 && hyprctl hyprpaper wallpaper 'eDP-1,/home/bow/.config/hypr/wallpaper.jpg'")
    hl.exec_cmd("hypridle")
end)
