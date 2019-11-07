optirun intel-virtual-output
xrandr --newmode "1920x1080_60.00"  172.80  1920 2040 2248 2576  1080 1081 1084 1118
xrandr --addmode VIRTUAL5 1920x1080_60.00
xrandr --output VIRTUAL4 --mode VIRTUAL4.449-1920x1080 --pos 1920x0 --rotate normal \
        --output VIRTUAL5 --mode 1920x1080_60.00 --pos 0x0 --rotate normal \
        --output eDP1 --primary --mode 1920x1080 --pos 964x1080 --rotate normal

