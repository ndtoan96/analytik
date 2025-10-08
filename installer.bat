@echo off
where uv >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo UV is not installed. Attempting to install UV...
    powershell -ExecutionPolicy Bypass -c "irm https://github.com/astral-sh/uv/releases/download/0.8.24/uv-installer.ps1 | iex"
)

%USERPROFILE%\.local\bin\uv.exe tool install https://github.com/ndtoan96/analytik/releases/download/v0.3.0/analytik-0.3.0-py3-none-any.whl
if %ERRORLEVEL% neq 0 (
    echo Failed to install analytik. Exiting.
    pause
    exit /b 1
)

%USERPROFILE%\.local\bin\uv.exe tool install playwright
if %ERRORLEVEL% neq 0 (
    echo Failed to install Playwright. Exiting.
    pause
    exit /b 1
)

%USERPROFILE%\.local\bin\uv.exe tool run playwright install chromium
if %ERRORLEVEL% neq 0 (
    echo Failed to install Chromium for Playwright. Exiting.
    pause
    exit /b 1
)

echo @echo off > analytik.bat
echo %USERPROFILE%\.local\bin\uv.exe tool run analytik >> analytik.bat

echo Installation complete, press any key to close
pause
