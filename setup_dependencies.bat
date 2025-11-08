@echo off
REM ================================================================
REM Local Model Runner - Automated Dependency Setup
REM ================================================================

title Local Model Runner - Dependency Setup

:MENU
cls
echo ================================================================
echo Local Model Runner - Dependency Setup
echo ================================================================
echo.
echo This script will help you download and build required dependencies.
echo.
echo Required dependencies:
echo   1. SQLite3 DLL (automatic download)
echo   2. llama.cpp DLL (needs building)
echo.
echo Choose build option for llama.cpp:
echo.
echo   [1] ROCm Build (AMD GPU acceleration)
echo   [2] CPU-Only Build (no GPU, slower)
echo   [3] Download SQLite3 only
echo   [4] Exit
echo.
echo ================================================================
set /p choice="Enter choice (1-4): "

if "%choice%"=="1" goto ROCM_BUILD
if "%choice%"=="2" goto CPU_BUILD
if "%choice%"=="3" goto SQLITE_ONLY
if "%choice%"=="4" goto EXIT

echo Invalid choice!
timeout /t 2 >nul
goto MENU

:ROCM_BUILD
cls
echo ================================================================
echo Building llama.cpp with ROCm (AMD GPU)
echo ================================================================
echo.

REM Check ROCm
where hipcc >nul 2>&1
if errorlevel 1 (
    echo ERROR: ROCm not detected!
    echo.
    echo Please install ROCm from: https://rocm.docs.amd.com
    echo.
    echo After installing ROCm, run this script again.
    echo.
    pause
    goto MENU
)

echo ROCm detected!
echo.

REM Download SQLite3 first
call build_tools\download_sqlite3.bat

echo.
echo ================================================================
echo Building llama.cpp with ROCm...
echo ================================================================
echo.

cd build_tools
call build_llama_rocm.bat
cd ..

goto COMPLETE

:CPU_BUILD
cls
echo ================================================================
echo Building llama.cpp (CPU-Only)
echo ================================================================
echo.
echo NOTE: This will NOT use GPU acceleration.
echo       Models will run on CPU only (slower).
echo.

REM Download SQLite3 first
call build_tools\download_sqlite3.bat

echo.
echo ================================================================
echo Building llama.cpp (CPU-only)...
echo ================================================================
echo.

cd build_tools
call build_llama_cpu.bat
cd ..

goto COMPLETE

:SQLITE_ONLY
cls
echo ================================================================
echo Downloading SQLite3 DLL only
echo ================================================================
echo.

call build_tools\download_sqlite3.bat

echo.
echo SQLite3 downloaded!
echo.
echo You still need llama.dll:
echo   - Run this script again and choose option 1 or 2
echo   - OR manually build llama.cpp and copy llama.dll here
echo.
pause
goto MENU

:COMPLETE
cls
echo.
echo ================================================================
echo SETUP COMPLETE!
echo ================================================================
echo.

REM Check if DLLs exist
set SQLITE_OK=0
set LLAMA_OK=0

if exist "sqlite3.dll" (
    echo [OK] sqlite3.dll found
    set SQLITE_OK=1
) else (
    echo [MISSING] sqlite3.dll NOT found
)

if exist "llama.dll" (
    echo [OK] llama.dll found
    set LLAMA_OK=1
) else (
    echo [MISSING] llama.dll NOT found
)

echo.

if %SQLITE_OK%==1 if %LLAMA_OK%==1 (
    echo ================================================================
    echo ALL DEPENDENCIES READY!
    echo ================================================================
    echo.
    echo Next steps:
    echo   1. Open LocalModelRunner.dpr in Delphi 12
    echo   2. Build the project (Project -^> Build)
    echo   3. Run the application!
    echo.
) else (
    echo ================================================================
    echo WARNING: Some dependencies are missing!
    echo ================================================================
    echo.
    echo Please check the errors above and try again.
    echo.
)

pause
goto MENU

:EXIT
echo.
echo Exiting...
exit /b 0
