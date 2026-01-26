#!/bin/bash

while true; do
    if [ -p /tmp/cava.txt ]; then
        od -An -tu1 -N10 /tmp/cava.txt 2>/dev/null | awk '{
            printf "["
            for(i=1; i<=NF; i++) {
                height = int(($i / 255) * 145)
                if(i > 1) printf ","
                printf "%d", height
            }
            printf "]\n"
            fflush()
        }'
    else
        echo "[0,0,0,0,0,0,0,0,0,0]"
        sleep 1
    fi
done