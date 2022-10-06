#/bin/bash

xrandr --dpi 81

#set up high DPI monitor
xrandr --output eDP-1 --mode 3840x2400 --pos 0x0

xrandr --output HDMI-1 --mode 2560x1080 --pos 3840x0 --scale 2x2
