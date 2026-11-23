@echo off
REM Run Godot directly execute node_2d.tscn using environment variable with default

if "%GODOT_PATH%"=="" (
    set "GODOT_PATH=C:\Users\russj\Documents\Godot_v4.6.1-stable_win64.exe\Godot_v4.6.1-stable_win64_console.exe"
)

pushd "%~dp0godot-chess\godot-chess"

if exist "%GODOT_PATH%" (
    "%GODOT_PATH%" node_2d.tscn
) else (
    where godot >nul 2>&1
    if %errorlevel% equ 0 (
        godot node_2d.tscn
    ) else (
        echo Godot executable not found at "%GODOT_PATH%" or in PATH.
        pause
    )
)

popd
