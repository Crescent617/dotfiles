#!/usr/bin/env bash

while true; do
  # Get the current hour in 24-hour format
  current_hour=$(date +%H)

  # Check if the current hour is between 18 (6 PM) and 6 (6 AM)
  if ((current_hour >= 20 || current_hour < 8)); then
    # Set dark mode
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  else
    # Set light mode
    dconf write /org/gnome/desktop/interface/color-scheme "'default'"
  fi

  # Sleep for an hour before checking again
  sleep 600
done
