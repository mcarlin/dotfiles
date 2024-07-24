#!/bin/sh

source "$HOME/.config/sketchybar/icons.sh"

# The $SELECTED variable is available for space components and indicates if
# the space invoking this script (with name: $NAME) is currently selected:
# https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item

sketchybar --set $NAME background.drawing=$SELECTED \
	icon.highlight=$SELECTED \
	label.highlight=$SELECTED

if [[ $SENDER == "space_change" ]];
then
  cat "$INFO" | jq .
fi

