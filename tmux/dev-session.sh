#!/usr/bin/env bash

# Simple tmux session - just 3 zsh panes
# Layout: 50% left | 25% upper-right + 25% lower-right

# Get current directory name for session name
DIR_NAME=$(basename "$(pwd)" | tr '.' '_')
SESSION_NAME="${1:-$DIR_NAME}"

# Check if session exists and attach, otherwise create new
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    tmux attach-session -t "$SESSION_NAME"
else
    # Create and attach in one go
    tmux new-session -s "$SESSION_NAME" -c "$(pwd)" \; \
      split-window -h -c "$(pwd)" \; \
      split-window -v -c "$(pwd)" \; \
      select-layout main-vertical
fi