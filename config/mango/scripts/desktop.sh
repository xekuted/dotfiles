#!/usr/bin/env bash
set -euo pipefail

STATE="$XDG_RUNTIME_DIR/mango-show-desktop"
LOG="$XDG_RUNTIME_DIR/mango-show-desktop.log"

: > "$LOG"

if [[ -s "$STATE" ]]; then
    # Restore whatever we previously minimized
    while read -r id; do
        [[ -z "$id" ]] && continue
        mmsg dispatch restore_minimized "client,$id" >>"$LOG" 2>&1 \
            || echo "restore failed for $id" >>"$LOG"
    done < "$STATE"
    rm -f "$STATE"
else
    # Snapshot currently visible, non-minimized clients on the active tag
    mmsg get all-clients 2>>"$LOG" \
        | jq -r '.clients[] | select(.is_visible == true and .is_minimized == false) | .id' \
        > "$STATE"

    if [[ ! -s "$STATE" ]]; then
        echo "no visible clients found to hide" >>"$LOG"
        rm -f "$STATE"
        exit 0
    fi

    while read -r id; do
        [[ -z "$id" ]] && continue
        mmsg dispatch minimized "client,$id" >>"$LOG" 2>&1 \
            || echo "minimize failed for $id" >>"$LOG"
    done < "$STATE"
fi
