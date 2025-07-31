#!/bin/sh

# Load fonts
source "$CONFIG_DIR/fonts.sh"

SPOTIFY_EVENT="com.spotify.client.PlaybackStateChanged"

sketchybar --add event spotify_change $SPOTIFY_EVENT

spotify=(
  icon="$($PLUGIN_DIR/icon_map_fn.sh Spotify)"
  icon.font="$FONT_APP"
  label.drawing=off
  script="$PLUGIN_DIR/spotify.sh"
)

sketchybar --add item spotify e \
           --set spotify "${spotify[@]}" \
           --subscribe spotify spotify_change
