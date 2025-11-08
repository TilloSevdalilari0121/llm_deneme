@echo off
REM ================================================================
REM llama.cpp CPU-Only Build Script for Windows
REM ================================================================
REM Requires:
REM - CMake (https://cmake.org/download/)
REM - Visual Studio 2022 with C++ tools
REM ================================================================

echo ================================================================
echo llama.cpp CPU-Only Build Script
echo ================================================================
echo.
echo NOTE: This builds CPU-only version (no GPU acceleration)
echo For AMD GPU support, use build_llama_rocm.bat instead
echo.

REM Clone llama.cpp if not exists
if not exist "llama.cpp" (
    echo Cloning llama.cpp repository...
    git clone https://github.com/ggerganov/llama.cpp.git
    if errorlevel 1 (
        echo ERROR: Failed to clone repository!
        pause
        exit /b 1
    )
)

cd llama.cpp

REM Create build directory
if exist "build" rd /s /q build
mkdir build
cd build

echo.
echo Configuring CMake for CPU-only build...
echo.

REM Configure CPU-only
cmake .. ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DBUILD_SHARED_LIBS=ON

if errorlevel 1 (
    echo ERROR: CMake configuration failed!
    pause
    exit /b 1
)

echo.
echo Building llama.cpp (CPU-only)...
echo This may take 5-10 minutes...
echo.

cmake --build . --config Release

if errorlevel 1 (
    echo ERROR: Build failed!
    pause
    exit /b 1
)

echo.
echo ================================================================
echo BUILD SUCCESSFUL!
echo ================================================================
echo.

REM Copy DLL to project root
if exist "bin\Release\llama.dll" (
    copy /Y "bin\Release\llama.dll" "..\..\..\llama.dll"
    echo llama.dll copied to project root
) else if exist "Release\llama.dll" (
    copy /Y "Release\llama.dll" "..\..\..\llama.dll"
    echo llama.dll copied to project root
) else (
    echo WARNING: Could not find llama.dll in expected location
    echo Please manually copy from build directory
)

echo.
echo Done! Check for llama.dll in the project root.
echo.
echo IMPORTANT: Set GPU Layers = 0 in settings (CPU-only build)
pause
