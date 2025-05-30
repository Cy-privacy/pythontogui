@echo off
echo Building Lunar executable...

:: Install PyInstaller if not already installed
pip install pyinstaller

:: Build the executable
pyinstaller --clean build.spec

echo Build complete! Check the 'dist' folder for Lunar.exe
pause