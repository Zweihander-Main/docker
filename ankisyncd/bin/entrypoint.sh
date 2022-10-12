#!/bin/sh
# file: entrypoint.sh

echo "Starting anki-sync-server"
python3 -m ankisyncd
