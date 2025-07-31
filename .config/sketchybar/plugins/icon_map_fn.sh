#!/bin/sh

source "$CONFIG_DIR/plugins/icon_map.sh"

__icon_map "$1"
echo "$icon_result"
