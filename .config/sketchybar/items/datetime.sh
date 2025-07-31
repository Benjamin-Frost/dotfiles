#!/bin/sh

datetime=(
  icon=􀧞
  update_freq=30
  script="$PLUGIN_DIR/datetime.sh"
)

sketchybar --add item datetime right \
           --set datetime "${datetime[@]}"
