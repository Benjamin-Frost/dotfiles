#!/bin/sh

# Load fonts
source "$CONFIG_DIR/fonts.sh"

PHANTOM_WORKSPACE="10"
DEFAULT_MONITOR="1"

sketchybar --add event aerospace_workspace_change \
           --add event aerospace_monitor_change

sketchybar --add item monitor_change_handler left \
           --set monitor_change_handler \
                 drawing=off \
                 script="$CONFIG_DIR/plugins/aerospace.sh update_cache" \
           --subscribe monitor_change_handler \
                       aerospace_monitor_change \
                       space_change

# Workspace items
for sid in $(aerospace list-workspaces --all); do
  [ "$sid" = "$PHANTOM_WORKSPACE" ] && continue

  monitor=$(aerospace list-windows --workspace "$sid" --format "%{monitor-appkit-nsscreen-screens-id}")
  monitor=${monitor:-$DEFAULT_MONITOR}

  space=(
    display=$monitor
    icon=$sid
    icon.padding_left=8
    icon.padding_right=8
    label.font="$FONT_APP"
    label.padding_left=0
    label.padding_right=0
    label.y_offset=-1
    background.color=0x40ffffff
    background.corner_radius=5
    background.height=24
    background.drawing=off
    script="$CONFIG_DIR/plugins/aerospace.sh $sid"
  )

  sketchybar --add item space.$sid left \
             --set space.$sid "${space[@]}" \
             --subscribe space.$sid aerospace_workspace_change
done
