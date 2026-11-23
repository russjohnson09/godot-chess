@echo off
REM Run Godot directly execute node_2d.tscn using environment variable with default, recording video and exiting after 10 seconds

if "%GODOT_PATH%"=="" (
    set "GODOT_PATH=C:\Users\russj\Documents\Godot_v4.6.1-stable_win64.exe\Godot_v4.6.1-stable_win64_console.exe"
)

pushd "%~dp0godot-chess\godot-chess"

if exist "%GODOT_PATH%" (
    "%GODOT_PATH%" --write-movie output.avi --fixed-fps 60 node_2d.tscn
) else (
    where godot >nul 2>&1
    if %errorlevel% equ 0 (
        godot --write-movie output.avi --fixed-fps 60 node_2d.tscn
    ) else (
        echo Godot executable not found at "%GODOT_PATH%" or in PATH.
        pause
    )
)

popd
