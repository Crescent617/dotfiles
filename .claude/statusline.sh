#!/usr/bin/env bash

# Read JSON input from stdin
input=$(cat)

# Example input JSON structure:
# {
#   "hook_event_name": "Status",
#   "session_id": "abc123...",
#   "transcript_path": "/path/to/transcript.json",
#   "cwd": "/current/working/directory",
#   "model": {
#     "id": "claude-opus-4-1",
#     "display_name": "Opus"
#   },
#   "workspace": {
#     "current_dir": "/current/working/directory",
#     "project_dir": "/original/project/directory"
#   },
#   "version": "1.0.80",
#   "output_style": {
#     "name": "default"
#   },
#   "cost": {
#     "total_cost_usd": 0.01234,
#     "total_duration_ms": 45000,
#     "total_api_duration_ms": 2300,
#     "total_lines_added": 156,
#     "total_lines_removed": 23
#   }
# }

# Extract values using jq
MDL=$(echo "$input" | jq -r '.model.display_name')
CWD=$(echo "$input" | jq -r '.workspace.current_dir')
LINES_ADDED=$(echo "$input" | jq -r '.cost.total_lines_added')
LINES_REMOVED=$(echo "$input" | jq -r '.cost.total_lines_removed')
# cost in USD 两位小数
COST=$(echo "$input" | jq -r '.cost.total_cost_usd' | awk '{printf "%.2f", $0}')
DURATION=$(echo "$input" | jq -r '.cost.total_duration_ms' | awk '{printf "%.0f", $0 / 1000}') # convert ms to seconds

# beautify the output with emojis
parts=(
  "🧠 $MDL"
  "📂 $CWD"
  " $LINES_ADDED  $LINES_REMOVED"
  "💰 $COST USD"
  "⏱️ $DURATION s"
)

delimiter=" | "
# Output the status line
len=${#parts[@]}
for ((i = 0; i < len; i++)); do
  if [ $i -eq $((len - 1)) ]; then
    printf "%s" "${parts[i]}"
  else
    printf "%s%s" "${parts[i]}" "$delimiter"
  fi
done
