@echo off
powershell -ExecutionPolicy Bypass -c "irm https://github.com/astral-sh/uv/releases/download/0.8.24/uv-installer.ps1 | iex"
uv tool install git+https://github.com/ndtoan96/analytik.git
uv tool install playwright
uv tool run playwright install chromium
echo @echo off > analytik.bat
echo uv tool run analytik >> analytik.bat
echo Installation complete, press any key to close
pause
