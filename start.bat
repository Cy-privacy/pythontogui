@echo off
setlocal enabledelayedexpansion

echo Checking system requirements...

:: Check if Python is installed
where python > nul 2>&1
if %errorlevel% neq 0 (
    echo Python 3.10.5 is not installed.
    echo Downloading Python installer...
    powershell -Command "(New-Object Net.WebClient).DownloadFile('https://www.python.org/ftp/python/3.10.5/python-3.10.5-amd64.exe', 'python_install.exe')"
    
    if exist python_install.exe (
        echo Installing Python 3.10.5...
        start /wait python_install.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
        del python_install.exe
        
        :: Refresh environment variables
        call refreshenv.cmd 2>nul
        if %errorlevel% neq 0 (
            :: If refreshenv is not available, modify PATH directly
            set "PATH=%PATH%;%LOCALAPPDATA%\Programs\Python\Python310;%LOCALAPPDATA%\Programs\Python\Python310\Scripts"
        )
    ) else (
        echo Failed to download Python installer.
        echo Please download and install Python 3.10.5 manually from: https://www.python.org/downloads/release/python-3105/
        pause
        exit /b 1
    )
)

:: Verify Python installation
python --version > nul 2>&1
if %errorlevel% neq 0 (
    echo Python installation failed or PATH not updated.
    echo Please restart your computer and try again.
    pause
    exit /b 1
)

:: Check for pip and upgrade it
python -m ensurepip --upgrade
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
where nvcc > nul 2>&1
if %errorlevel% neq 0 (
    echo Installing CUDA Toolkit 12.6...
    echo This may take a while...
    
    :: Download CUDA installer
    powershell -Command "(New-Object Net.WebClient).DownloadFile('https://developer.download.nvidia.com/compute/cuda/12.6.0/local_installers/cuda_12.6.0_windows.exe', 'cuda_install.exe')"
    
    if exist cuda_install.exe (
        echo Running CUDA installer...
        start /wait cuda_install.exe /s /n
        del cuda_install.exe
        
        :: Add CUDA to PATH
        set "PATH=%PATH%;C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.6\bin"
    ) else (
        echo Failed to download CUDA installer.
        echo Please install CUDA 12.6 manually from: https://developer.nvidia.com/cuda-downloads
        pause
        exit /b 1
    )
)

:: Install PyTorch with CUDA support
echo Installing PyTorch with CUDA support...
python -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu126

:: Install other requirements
echo Installing required packages...
python -m pip install -r requirements.txt

:: Start the program
echo Starting Lunar...
python lunar.py

pause