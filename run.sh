#!/usr/bin/env bash
cd "$(dirname "$0")/godot-chess/godot-chess"

if command -v godot &> /dev/null; then
    godot node_2d.tscn
elif command -v godot4 &> /dev/null; then
    godot4 node_2d.tscn
else
    echo "Godot executable not found in PATH."
    exit 1
fi
