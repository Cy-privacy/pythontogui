@echo off
echo Checking NVIDIA requirements...

:: Check NVIDIA GPU and drivers
nvidia-smi > nul 2>&1
if %errorlevel% neq 0 (
    echo [X] NVIDIA GPU drivers not found
    echo Please install NVIDIA drivers from:
    echo https://www.nvidia.com/download/index.aspx
    echo.
    pause
    exit /b 1
)

:: Check CUDA
nvcc --version > nul 2>&1
if %errorlevel% neq 0 (
    echo [X] CUDA Toolkit not found
    echo Please install CUDA Toolkit from:
    echo https://developer.nvidia.com/cuda-downloads
    echo.
    pause
    exit /b 1
)

echo Starting Lunar...
Lunar.exe

pause