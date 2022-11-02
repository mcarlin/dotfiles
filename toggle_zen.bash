#/usr/bin/env bash

current_space=$(yabai -m query --spaces | jq '.[] | select(."is-visible" == true and ."has-focus" == true) | .index');
if [ $(yabai -m config --space $current_space right_padding) -eq 10 ] 
then
	yabai -m space --padding abs:10:10:450:450
elif [ $(yabai -m config --space $current_space right_padding) -eq 450 ] 
then
	yabai -m space --padding abs:10:10:900:900
else
	yabai -m space --padding abs:10:10:10:10
fi
