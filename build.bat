@echo off
echo Building Lunar executable...

:: Check if Python is installed
python --version > nul 2>&1
if %errorlevel% neq 0 (
    echo [X] Python is required to build the executable
    echo Please install Python from: https://www.python.org/downloads/
    pause
    exit /b 1
)

:: Install requirements
echo Installing build requirements...
pip install -r requirements.txt
pip install pyinstaller

:: Build the executable
echo Building executable...
pyinstaller --clean build.spec

echo Build complete! Check the 'dist' folder for Lunar.exe
pause