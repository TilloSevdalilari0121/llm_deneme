@echo off
REM ================================================================
REM SQLite3 DLL Download Script
REM ================================================================

echo Downloading SQLite3 DLL for Windows (64-bit)...
echo.

set SQLITE_VERSION=3470200
set SQLITE_YEAR=2024
set SQLITE_URL=https://www.sqlite.org/%SQLITE_YEAR%/sqlite-dll-win-x64-%SQLITE_VERSION%.zip
set OUTPUT_FILE=sqlite3.zip

echo Download URL: %SQLITE_URL%
echo.

REM Download using PowerShell
powershell -Command "& {Invoke-WebRequest -Uri '%SQLITE_URL%' -OutFile '%OUTPUT_FILE%'}"

if not exist "%OUTPUT_FILE%" (
    echo ERROR: Download failed!
    echo.
    echo Manual download:
    echo 1. Go to: https://www.sqlite.org/download.html
    echo 2. Download: "Precompiled Binaries for Windows" - sqlite-dll-win-x64
    echo 3. Extract sqlite3.dll to this folder
    pause
    exit /b 1
)

echo.
echo Extracting...
powershell -Command "& {Expand-Archive -Path '%OUTPUT_FILE%' -DestinationPath '.' -Force}"

if exist "sqlite3.dll" (
    echo.
    echo SUCCESS! sqlite3.dll downloaded and extracted.
    del "%OUTPUT_FILE%"
) else (
    echo ERROR: Extraction failed!
    pause
    exit /b 1
)

echo.
echo Done!
pause
