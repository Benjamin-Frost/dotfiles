#!/bin/sh

PHANTOM_WORKSPACE="10"
DEFAULT_MONITOR="1"
CACHE_FILE="/tmp/sketchybar_workspace_monitors"

update_monitor_cache() {
  > "$CACHE_FILE"  # Clear cache file
  for sid in $(aerospace list-workspaces --all); do
    [ "$sid" = "$PHANTOM_WORKSPACE" ] && continue

    monitor=$(aerospace list-windows --workspace "$sid" --format "%{monitor-appkit-nsscreen-screens-id}")
    monitor=${monitor:-$DEFAULT_MONITOR}
    echo "$sid:$monitor" >> "$CACHE_FILE"
  done
}

get_cached_monitor() {
  [ ! -f "$CACHE_FILE" ] && update_monitor_cache
  monitor=$(grep "^$1:" "$CACHE_FILE" | cut -d: -f2)
  echo "${monitor:-$DEFAULT_MONITOR}"
}

# Update cache and refresh all workspaces items on monitor changes
if [ "$1" = "update_cache" ]; then
  update_monitor_cache

  for sid in $(aerospace list-workspaces --all); do
    [ "$sid" = "$PHANTOM_WORKSPACE" ] && continue
    monitor=$(get_cached_monitor "$sid")
    sketchybar --set space.$sid display="$monitor"
  done

  exit 0
fi

workspace_id=$1
[ "$workspace_id" = "$PHANTOM_WORKSPACE" ] && exit 0

# Get monitor for workspace
monitor=$(get_cached_monitor "$workspace_id")

if [ "$workspace_id" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set space.$workspace_id background.drawing=on display="$monitor"
else
  sketchybar --set space.$workspace_id background.drawing=off display="$monitor"
fi
