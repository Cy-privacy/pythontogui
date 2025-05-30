@echo off
echo Building Lunar executable...
pyinstaller --clean build.spec
echo Build complete! Check the 'dist' folder for Lunar.exe