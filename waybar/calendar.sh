#!/bin/bash
# ~/.config/waybar/calendar.sh

# Obtener el día actual
TODAY=$(date +%d)

# Generar el calendario en HTML
cal | awk -v today="$TODAY" '
{
    for (i = 1; i <= NF; i++) {
        if ($i == today) {
            $i = "<span color=\"#FFD700\"><b>" $i "</b></span>"
        }
    }
    print $0
}'
