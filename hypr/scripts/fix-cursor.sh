#!/bin/bash

# Wait for full startup
sleep 2

# Hide ALL cursor rendering from GDM/GNOME
gsettings set org.gnome.settings-daemon.plugins.cursor active false 2>/dev/null

# Kill GDM cursor processes
pkill -9 gsd-cursor 2>/dev/null
pkill -9 gsd-xsettings 2>/dev/null

# Force only ONE cursor (Hyprland's)
hyprctl keyword cursor:enable_hyprcursor true
hyprctl keyword cursor:no_hardware_cursors true

# Reset cursor position to force redraw
hyprctl dispatch movecursor 0 0
sleep 0.3
hyprctl setcursor Adwaita 24
hyprctl dispatch movecursor 960 540

echo "Cursor fix applied"
