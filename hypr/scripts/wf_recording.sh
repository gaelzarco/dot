#!/bin/bash
# Dependencies: wf-recorder, slurp

# Check for existing wf-recorder processes
if pgrep -x "wf-recorder" > /dev/null; then
  # If wf-recorder is running, kill the process
  pkill wf-recorder

  latest_recording=$(cat /tmp/latest_recording_filename)
  notify-send -t 2000 -a "Screen Record" "Recording Saved" "Recording saved as $latest_recording"

  # Clean up the filename cache
  [ -f /tmp/latest_recording_filename ] && rm /tmp/latest_recording_filename
else
  # No existing process, start a new recording
  # Get the current date and time in the desired format
  timestamp=$(date +"%Y%m%d_%H%M%S")

  # Create the new filename with the timestamp
  new_filename="$HOME/Videos/gx${timestamp}.mp4"

  # Cache the filename in /tmp
  echo "$new_filename" > /tmp/latest_recording_filename

  # Capture geometry with slurp (select screen area)
  geometry=$(slurp)

  # Check if ESC was pressed (slurp returns empty on ESC)
  if [ -z "$geometry" ]; then
    echo "ESC pressed. Exiting."
    exit 1
  fi

  # Run wf-recorder with the selected geometry
  wf-recorder --audio --file="$new_filename" -g "$geometry" &

  notify-send -t 2000 -a "Screen Record" "Recording Initialized..." "SUPER + SHIFT + R to stop"
fi
