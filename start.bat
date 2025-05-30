@echo off
echo Checking requirements...

:: Check Python
python --version > nul 2>&1
if %errorlevel% neq 0 (
    echo [X] Python 3.10.5 is not installed
    echo Please download and install Python 3.10.5 from:
    echo https://www.python.org/downloads/release/python-3105/
    echo.
    echo Make sure to check "Add Python to PATH" during installation
    echo.
) else (
    echo [✓] Python is installed
)

:: Check NVIDIA GPU and drivers
nvidia-smi > nul 2>&1
if %errorlevel% neq 0 (
    echo [X] NVIDIA GPU drivers not found
    echo Please install the latest NVIDIA drivers from:
    echo https://www.nvidia.com/download/index.aspx
    echo.
) else (
    echo [✓] NVIDIA drivers detected
)

:: Check CUDA
nvcc --version > nul 2>&1
if %errorlevel% neq 0 (
    echo [X] CUDA Toolkit not found
    echo Please install the latest CUDA Toolkit from:
    echo https://developer.nvidia.com/cuda-downloads
    echo.
) else (
    echo [✓] CUDA Toolkit detected
)

:: If all requirements are met, install packages and start
if %errorlevel% equ 0 (
    echo Installing required packages...
    pip install -r requirements.txt
    echo.
    echo Starting Lunar...
    python lunar.py
) else (
    echo.
    echo Please install the missing requirements and run this script again.
)

pause