#!/usr/bin/env bash

WEATHER="$(curl -s 'wttr.in/Spring?format=%c%f')"
length=${#WEATHER}
LABEL="$(echo "${WEATHER:3:length - 1}")"
ICON="$(echo "${WEATHER:0:1}")"

sketchybar -m --set $NAME label=$LABEL icon=$ICON
