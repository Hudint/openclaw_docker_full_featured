#!/bin/bash
set -e

# Start wacli sync daemon in background
echo "Starting wacli sync daemon in background..."
nohup sync-wacli &

# Execute the original command (from base image or docker run)
exec "$@"
