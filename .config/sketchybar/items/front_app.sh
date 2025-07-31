#!/bin/sh

# Load fonts
source "$CONFIG_DIR/fonts.sh"

front_app=(
  icon.font="$FONT_APP"
  script="$PLUGIN_DIR/front_app.sh"
)

sketchybar --add item front_app q \
           --set front_app "${front_app[@]}" \
           --subscribe front_app front_app_switched
