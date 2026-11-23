@echo off
REM Run Godot headless or directly execute node_2d.tscn
REM Adjust the path to godot executable if needed, or assume 'godot' is in PATH.

pushd "%~dp5"
cd /d "%~dp0godot-chess\godot-chess"

@REM  C:\Users\russj\Documents\Godot_v4.6.1-stable_win64.exe\Godot_v4.6.1-stable_win64_console.exe
@REM  C:\Users\russj\Documents\Godot_v4.6.1-stable_win64.exe\Godot_v4.6.1-stable_win64.exe


REM Try standard godot command or common installation paths if needed
where godot >nul 2>&1
if %errorlevel% equ 0 (
    godot node_2d.tscn
) else (
    REM Fallback to common Windows paths or prompt user
    if exist "C:\Users\russj\Documents\Godot_v4.6.1-stable_win64.exe\Godot_v4.6.1-stable_win64_console.exe" (
        "C:\Users\russj\Documents\Godot_v4.6.1-stable_win64.exe\Godot_v4.6.1-stable_win64_console.exe" node_2d.tscn
    ) else (
        echo Godot executable not found in PATH or standard location. Please ensure Godot is installed and in your PATH.
        pause
    )
)

popd
