#!/bin/bash

# Default JSON output for stopped/no media state
stopped_json='{"status":"NO_PLAYER","title":"No media playing","artist":"","album":"","artUrl":""}'
delimiter=$'\x1f'

# Function to output JSON with a given status
output_json() {
  local status="$1"
  local title="${2:-No media playing}"
  local artist="${3:-}"
  local album="${4:-}"
  local arturl="${5:-}"
  local position="${6:-0:00}"
  local length="${7:-0:00}"
  local positionSec="${8:-0}"
  local lengthSec="${9:-0}"
  
cat << EOF
{"status":"${status^^}","title":"${title}","artist":"${artist}","album":"${album}","artUrl":"${arturl}","position":"${position}","length":"${length}","positionSec":${positionSec},"lengthSec":${lengthSec}}
EOF
}

if ! playerctl -p spotify status &>/dev/null; then
  output_json "NO_PLAYER"
  exit 0
fi

# metadata=$(playerctl -p spotify metadata --format '{{status}}$'\x1f'{{title}}|{{artist}}$'\x1f'{{album}}$'\x1f'{{mpris:artUrl}}$'\x1f'{{ duration(position) }}$'\x1f'{{ duration(mpris:length) }}$'\x1f'{{position}}$'\x1f'{{mpris:length}}' 2>/dev/null)
metadata=$(playerctl -p spotify metadata --format "{{status}}${delimiter}{{title}}${delimiter}{{artist}}${delimiter}{{album}}${delimiter}{{mpris:artUrl}}${delimiter}{{ duration(position) }}${delimiter}{{ duration(mpris:length) }}${delimiter}{{position}}${delimiter}{{mpris:length}}" 2>/dev/null)
IFS=$delimiter read -r status title artist album arturl position length positionMicroSec lengthMicrosec <<< "$metadata"

# Convert length from microseconds to seconds
lengthSec=$(echo "$lengthMicrosec" | awk '{print $1/1000000}')
positionSec=$(echo "$positionMicroSec" | awk '{print $1/1000000}')  

# Download and store album art locally
local_art="/tmp/eww_cover.jpg"
if [[ -n "$arturl" ]]; then
  # Only download if URL has changed
  if [[ ! -f "$local_art" ]] || [[ "$(cat /tmp/eww_cover.url 2>/dev/null)" != "$arturl" ]]; then
    curl -s "$arturl" -o "$local_art"
    echo "$arturl" > /tmp/eww_cover.url
  fi
  arturl="$local_art"
else
  arturl=""
fi

# Output JSON
output_json "$status" "$title" "$artist" "$album" "$arturl" "$position" "$length" "$positionSec" "$lengthSec"