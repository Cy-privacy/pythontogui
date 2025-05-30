@echo off
setlocal enabledelayedexpansion

echo Checking system requirements...

:: Check if Python is installed
python --version > nul 2>&1
if %errorlevel% neq 0 (
    echo Python 3.10.5 is not installed.
    echo Downloading Python installer...
    
    :: Create a temporary directory for downloads
    mkdir temp 2>nul
    cd temp
    
    :: Download Python installer
    powershell -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.10.5/python-3.10.5-amd64.exe' -OutFile 'python_install.exe'"
    
    if exist python_install.exe (
        echo Installing Python 3.10.5...
        :: Run installer with UI to ensure proper installation
        start /wait python_install.exe
        
        :: Clean up
        cd ..
        rmdir /s /q temp
        
        :: Force PATH update for current session
        for /f "tokens=*" %%p in ('where python') do set "PYTHON_PATH=%%p"
        set "PATH=%PATH%;%PYTHON_PATH%"
        
        :: Verify installation
        python --version > nul 2>&1
        if !errorlevel! neq 0 (
            echo Python installation verification failed.
            echo Please try running the installer manually from: https://www.python.org/downloads/release/python-3105/
            pause
            exit /b 1
        )
    ) else (
        echo Failed to download Python installer.
        echo Please install Python 3.10.5 manually from: https://www.python.org/downloads/release/python-3105/
        pause
        exit /b 1
    )
)

:: Install and upgrade pip
echo Installing and upgrading pip...
python -m ensurepip --upgrade --default-pip
python -m pip install --upgrade pip

:: Check NVIDIA GPU
echo Checking NVIDIA GPU...
nvidia-smi > nul 2>&1
if %errorlevel% neq 0 (
    echo WARNING: NVIDIA GPU not detected or drivers not installed.
    echo Please install NVIDIA drivers from: https://www.nvidia.com/download/index.aspx
    echo Press any key to continue anyway...
    pause > nul
)

:: Install CUDA Toolkit
echo Checking CUDA installation...
nvcc --version > nul 2>&1
if %errorlevel% neq 0 (
    echo Installing CUDA Toolkit 12.6...
    echo This may take a while...
    
    :: Create temp directory for CUDA installer
    mkdir cuda_temp 2>nul
    cd cuda_temp
    
    :: Download CUDA installer
    powershell -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri 'https://developer.download.nvidia.com/compute/cuda/12.6.0/network_installers/cuda_12.6.0_windows_network.exe' -OutFile 'cuda_install.exe'"
    
    if exist cuda_install.exe (
        echo Running CUDA installer...
        start /wait cuda_install.exe
        
        :: Clean up
        cd ..
        rmdir /s /q cuda_temp
        
        :: Add CUDA to PATH
        set "PATH=%PATH%;C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.6\bin"
        
        :: Wait for installation to complete
        timeout /t 10 /nobreak > nul
    ) else (
        echo Failed to download CUDA installer.
        echo Please install CUDA 12.6 manually from: https://developer.nvidia.com/cuda-downloads
        pause
        exit /b 1
    )
)

:: Install PyTorch with CUDA support
echo Installing PyTorch with CUDA support...
python -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu126 --no-cache-dir

:: Install other requirements
echo Installing required packages...
python -m pip install -r requirements.txt --no-cache-dir

:: Start the program
echo Starting Lunar...
python lunar.py

pause