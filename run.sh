#!/usr/bin/env bash
cd "$(dirname "$0")/godot-chess/godot-chess"

GODOT_PATH="${GODOT_PATH:-/c/Users/russj/Documents/Godot_v4.6.1-stable_win64.exe/Godot_v4.6.1-stable_win64_console.exe}"

if [ -f "$GODOT_PATH" ]; then
    "$GODOT_PATH" --write-movie output_entry2.avi --fixed-fps 60 entry_2.tscn
elif command -v godot &> /dev/null; then
    godot --write-movie output_entry2.avi --fixed-fps 60 entry_2.tscn
elif command -v godot4 &> /dev/null; then
    godot4 --write-movie output_entry2.avi --fixed-fps 60 entry_2.tscn
else
    echo "Godot executable not found."
    exit 1
fi
