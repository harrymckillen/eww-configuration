#!/bin/bash
sleep 2
DIR="$(dirname "$0")"
cd "$DIR"
cava -p ./cava_config &
sleep 2
eww daemon &
sleep 2
eww open desktop-widget &
eww open media-player &