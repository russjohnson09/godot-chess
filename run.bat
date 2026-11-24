@echo off
REM Run Godot directly execute entry_2.tscn using environment variable with default, recording video and exiting after 5 seconds

if "%GODOT_PATH%"=="" (
    set "GODOT_PATH=C:\Users\russj\Documents\Godot_v4.6.1-stable_win64.exe\Godot_v4.6.1-stable_win64_console.exe"
)

pushd "%~dp0godot-chess\godot-chess"

if exist "%GODOT_PATH%" (
    "%GODOT_PATH%" --write-movie output_entry2.avi --fixed-fps 60 entry_2.tscn
) else (
    where godot >nul 2>&1
    if %errorlevel% equ 0 (
        godot --write-movie output_entry2.avi --fixed-fps 60 entry_2.tscn
    ) else (
        echo Godot executable not found at "%GODOT_PATH%" or in PATH.
        pause
    )
)

popd
