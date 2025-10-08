@echo off
where uv >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo UV is not installed. Attempting to install UV...
    powershell -ExecutionPolicy Bypass -c "irm https://github.com/astral-sh/uv/releases/download/0.8.24/uv-installer.ps1 | iex"
)

uv tool install https://github.com/ndtoan96/analytik/releases/download/v0.1.0/analytik-0.1.0-py3-none-any.whl
if %ERRORLEVEL% neq 0 (
    echo Failed to install analytik. Exiting.
    pause
    exit /b 1
)

uv tool install playwright
if %ERRORLEVEL% neq 0 (
    echo Failed to install Playwright. Exiting.
    pause
    exit /b 1
)

uv tool run playwright install chromium
if %ERRORLEVEL% neq 0 (
    echo Failed to install Chromium for Playwright. Exiting.
    pause
    exit /b 1
)

echo @echo off > analytik.bat
if %ERRORLEVEL% neq 0 (
    echo Failed to create analytik.bat. Exiting.
    pause
    exit /b 1
)

echo uv tool run analytik >> analytik.bat
if %ERRORLEVEL% neq 0 (
    echo Failed to append to analytik.bat. Exiting.
    pause
    exit /b 1
)

echo Installation complete, press any key to close
pause
