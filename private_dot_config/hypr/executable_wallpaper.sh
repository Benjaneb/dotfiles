#!/bin/sh
WALLPAPER_DIR=~/Pictures/wallpapers

images() {
    find $WALLPAPER_DIR -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | awk '{print "img:"$0}'
}

main() {
    choice=$(images | wofi -c ~/.config/wofi/wallpaper -s ~/.config/wofi/style-wallpaper.css --show dmenu --prompt "Select Wallpaper:" -n)
    selected_wallpaper=$(echo "$choice" | sed 's/^img://')
    hyprctl hyprpaper reload ,"$selected_wallpaper"
    wal -i "$selected_wallpaper" -n --cols16
    swaync-client --reload-css
    cat ~/.cache/wal/colors-kitty.conf > ~/.config/kitty/current-theme.conf
    color1=$(awk 'match($0, /color2=\47(.*)\47/,a) { print a[1] }' ~/.cache/wal/colors.sh)
    color2=$(awk 'match($0, /color3=\47(.*)\47/,a) { print a[1] }' ~/.cache/wal/colors.sh)
    #cava_config="$HOME/.config/cava/config"
    #sed -i "s/^gradient_color_1 = .*/gradient_color_1 = '$color1'/" $cava_config
    #sed -i "s/^gradient_color_2 = .*/gradient_color_2 = '$color2'/" $cava_config
    #pkill -USR2 cava 2>/dev/null
    source ~/.cache/wal/colors.sh && cp -r $wallpaper ~/wallpapers/pywallpaper.jpg
}
main
