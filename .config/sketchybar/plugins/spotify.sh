#!/bin/bash

MAX_LENGTH=30
HALF_LENGTH=$(((MAX_LENGTH + 1) / 2))
PLAYING_COLOR="0xffa6da95"
PAUSED_COLOR="0xffeed49f"

# Spotify JSON / $INFO comes in malformed, line below sanitizes it
SPOTIFY_JSON="$INFO"

update_track() {
  if [[ -z $SPOTIFY_JSON ]]; then
    sketchybar --set $NAME icon.color=$PAUSED_COLOR label.drawing=no
    return
  fi

  PLAYER_STATE=$(echo "$SPOTIFY_JSON" | jq -r '.["Player State"]')

  if [ $PLAYER_STATE = "Playing" ]; then
    TRACK="$(echo "$SPOTIFY_JSON" | jq -r .Name)"
    ARTIST="$(echo "$SPOTIFY_JSON" | jq -r .Artist)"

    # Calculations so it fits nicely
    TRACK_LENGTH=${#TRACK}
    ARTIST_LENGTH=${#ARTIST}

    if [ $((TRACK_LENGTH + ARTIST_LENGTH)) -gt $MAX_LENGTH ]; then
      # If the total length exceeds the max
      if [ $TRACK_LENGTH -gt $HALF_LENGTH ] && [ $ARTIST_LENGTH -gt $HALF_LENGTH ]; then
        # If both the track and artist are too long, cut both at half length - 1

        # If MAX_LENGTH is odd, HALF_LENGTH is calculated with an extra space, so give it an extra char
        TRACK="${TRACK:0:$((MAX_LENGTH % 2 == 0 ? HALF_LENGTH - 2 : HALF_LENGTH - 1))}…"
        ARTIST="${ARTIST:0:$((HALF_LENGTH - 2))}…"

      elif [ $TRACK_LENGTH -gt $HALF_LENGTH ]; then
        # Else if only the track is too long, cut it by the difference of the max length and artist length
        TRACK="${TRACK:0:$((MAX_LENGTH - ARTIST_LENGTH - 1))}…"
      elif [ $ARTIST_LENGTH -gt $HALF_LENGTH ]; then
        ARTIST="${ARTIST:0:$((MAX_LENGTH - TRACK_LENGTH - 1))}…"
      fi
    fi
    sketchybar --set $NAME label="${TRACK} - ${ARTIST}" label.drawing=yes icon.color=$PLAYING_COLOR

  elif [ $PLAYER_STATE = "Paused" ]; then
    sketchybar --set $NAME icon.color=$PAUSED_COLOR
  elif [ $PLAYER_STATE = "Stopped" ]; then
    sketchybar --set $NAME icon.color=$PAUSED_COLOR label.drawing=no
  else
    sketchybar --set $NAME icon.color=$PAUSED_COLOR
  fi
}

update_track
