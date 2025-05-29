@echo off
setlocal enabledelayedexpansion

echo Checking system requirements...

:: Check if Python is installed
python --version > nul 2>&1
if %errorlevel% neq 0 (
    echo Installing Python 3.10.5...
    curl -L "https://www.python.org/ftp/python/3.10.5/python-3.10.5-amd64.exe" --output python_install.exe
    python_install.exe /quiet InstallAllUsers=1 PrependPath=1
    del python_install.exe
)

:: Check CUDA installation
nvidia-smi > nul 2>&1
if %errorlevel% neq 0 (
    echo NVIDIA GPU not detected or drivers not installed.
    echo Please install NVIDIA drivers from: https://www.nvidia.com/download/index.aspx
    pause
    exit
)

:: Check CUDA version
nvcc --version > nul 2>&1
if %errorlevel% neq 0 (
    echo Installing CUDA Toolkit 12.6...
    curl -L "https://developer.download.nvidia.com/compute/cuda/12.6.0/local_installers/cuda_12.6.0_windows.exe" --output cuda_install.exe
    cuda_install.exe /s
    del cuda_install.exe
    
    :: Update PATH
    set "PATH=%PATH%;C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.6\bin"
)

:: Install PyTorch with CUDA support
echo Installing PyTorch with CUDA support...
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu126

:: Install other requirements
echo Installing required packages...
pip install -r requirements.txt

:: Start the program
echo Starting Lunar...
python lunar.py

pause