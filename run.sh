#!/usr/bin/env bash
cd "$(dirname "$0")/godot-chess/godot-chess"

GODOT_PATH="${GODOT_PATH:-/c/Users/russj/Documents/Godot_v4.6.1-stable_win64.exe/Godot_v4.6.1-stable_win64_console.exe}"

if [ -f "$GODOT_PATH" ]; then
    "$GODOT_PATH" node_2d.tscn
elif command -v godot &> /dev/null; then
    godot node_2d.tscn
elif command -v godot4 &> /dev/null; then
    godot4 node_2d.tscn
else
    echo "Godot executable not found."
    exit 1
fi
