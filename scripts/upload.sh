#!/usr/bin/env bash
set -euo pipefail

REMOTE_USER="amalsthai"
REMOTE_HOST="192.168.3.10"
REMOTE_PATH="~/boxing_clock/src/"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_SRC="$SCRIPT_DIR/../src/"

rsync -avz --delete \
    --exclude '__pycache__' \
    --exclude '*.pyc' \
    "$LOCAL_SRC" "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_PATH}"
