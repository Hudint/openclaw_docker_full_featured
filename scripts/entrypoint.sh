#!/bin/bash
set -e

# Start wacli sync daemon in background (opt-in via env variable)
if [ "$AUTO_SYNC_WACLI" = "true" ]; then
  echo "Starting wacli sync daemon in background..."
  nohup sync-wacli &
fi

# Execute the original command (from base image or docker run)
exec "$@"
