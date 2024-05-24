#!/bin/bash

export PATH="${PATH}:${HOME}/.local/bin/"


DIR=$HOME/wallpaper
PICS=($(ls ${DIR}))
echo $PICS

RANDOMPICS=${PICS[ $RANDOM % ${#PICS[@]} ]}

swww img ${DIR}/${RANDOMPICS} --transition-type grow --transition-fps 60 --transition-duration 0.2 --transition-pos 0.810,0.972 --transition-bezier 0.65,0,0.35,1 --transition-step 255
wal -q -i ${DIR}/${RANDOMPICS}
