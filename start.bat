@echo off
echo Checking requirements...

:: Check Python
python --version > nul 2>&1
if %errorlevel% neq 0 (
    echo [X] Python is not installed
    echo Please download and install the latest Python from:
    echo https://www.python.org/downloads/
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
    echo Please install NVIDIA drivers from:
    echo https://www.nvidia.com/download/index.aspx
    echo.
) else (
    echo [✓] NVIDIA drivers detected
)

:: Check CUDA
nvcc --version > nul 2>&1
if %errorlevel% neq 0 (
    echo [X] CUDA Toolkit not found
    echo Please install CUDA Toolkit from:
    echo https://developer.nvidia.com/cuda-downloads
    echo.
) else (
    echo [✓] CUDA Toolkit detected
)

:: If Python is installed, proceed with package installation and start
python --version > nul 2>&1
if %errorlevel% equ 0 (
    echo Installing required packages...
    python -m pip install --upgrade pip
    pip install -r requirements.txt --no-cache-dir
    
    echo.
    echo Starting Lunar...
    python lunar.py
) else (
    echo.
    echo Please install Python and run this script again.
)

pause