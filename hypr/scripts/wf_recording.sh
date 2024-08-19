#!/bin/bash

# Check for existing wf-recorder processes
if pgrep -x "wf-recorder" > /dev/null; then
  # If wf-recorder is running, kill the process
  pkill -SIGINT wf-recorder

  latest_recording=$(cat /tmp/latest_recording_filename)
  notify-send "Recording Saved" "Recording saved as $latest_recording"

  # Clean up the PID file if it exists
  [ -f /tmp/latest_recording_filename ] && rm /tmp/latest_recording_filename
else
  # No existing process, start a new recording
  # Get the current date and time in the desired format
  timestamp=$(date +"%Y%m%d_%H%M%S")

  # Create the new filename with the timestamp
  new_filename="$HOME/Videos/gx${timestamp}.mp4"

  # Cache the filename in /tmp
  echo "$new_filename" > /tmp/latest_recording_filename

  # Run wf-recorder with the new filename
  wf-recorder --audio --file="$new_filename" -g "$(slurp)" &

  notify-send "Recording Initialized..." "Super + R to stop"
fi
