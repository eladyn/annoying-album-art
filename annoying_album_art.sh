#!/bin/bash

chgcnt=0

playerctl -F metadata | sed -Eu 's/^[a-zA-Z]+ //g' | while read line; do
  datatype="$(echo "$line" | sed -E 's/^([a-zA-Z:]+)\s+.*/\1/')"
  value="$(echo "$line" | sed -E 's/^[a-zA-Z:]+\s+//g')"
  case "$datatype" in
    "xesam:title")
      chgcnt=$((chgcnt + 1))
      title="$value" ;;
    "xesam:artist")
      chgcnt=$((chgcnt + 1))
      artist="$value" ;;
    "mpris:artUrl")
      chgcnt=$((chgcnt + 1))
      artUrl="$value" ;;
  esac

  if [ "$chgcnt" -ge 3 ]; then
    chgcnt=0
    if [ -n "$pid" ]; then
      kill "$pid"
    fi
    # remove old file
    if [ -f "$filename" ]; then
      rm "$filename"
    fi
    filename=/tmp/$(echo "$title - $artist" | sed 's/\//|/g')
    echo "$artUrl"
    wget -O "$filename" "$artUrl"
    eog -n "$filename" &
    pid="$!"
  fi
done
