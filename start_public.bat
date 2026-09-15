@echo off
setlocal EnableExtensions
chcp 65001 >nul
title HimBaza Public Launcher

set "PROJECT_DIR=%~dp0"
set "BACKEND_DIR=%PROJECT_DIR%backend"
set "FRONTEND_DIR=%PROJECT_DIR%frontend"
set "LAN_IP=192.168.3.56"
set "CLOUDFLARED=C:\cloudflared\cloudflared.exe"

echo ============================================
echo   HimBaza: public production launch
echo ============================================
echo.

if not exist "%BACKEND_DIR%\main.py" (
    echo ERROR: Ne naiden "%BACKEND_DIR%\main.py"
    pause
    exit /b 1
)

if not exist "%BACKEND_DIR%\.venv\Scripts\python.exe" (
    echo ERROR: Ne naiden "%BACKEND_DIR%\.venv\Scripts\python.exe"
    pause
    exit /b 1
)

if not exist "%FRONTEND_DIR%\package.json" (
    echo ERROR: Ne naiden "%FRONTEND_DIR%\package.json"
    pause
    exit /b 1
)

if not exist "%CLOUDFLARED%" (
    echo ERROR: Ne naiden cloudflared:
    echo %CLOUDFLARED%
    pause
    exit /b 1
)

echo [1/3] Zapusk FastAPI backend...
start "HimBaza Backend" cmd /k "cd /d ""%BACKEND_DIR%"" && ""%BACKEND_DIR%\.venv\Scripts\python.exe"" -m uvicorn main:app --host 0.0.0.0 --port 8000"

timeout /t 3 /nobreak >nul

echo [2/3] Sборка production frontend...
cd /d "%FRONTEND_DIR%"
call npm.cmd run build

if errorlevel 1 (
    echo.
    echo ERROR: npm run build zavershilsya s oshibkoy.
    pause
    exit /b 1
)

echo [3/3] Zapusk production frontend...
start "HimBaza Frontend Production" cmd /k "cd /d ""%FRONTEND_DIR%"" && npm.cmd run preview -- --host 0.0.0.0 --port 5173"

timeout /t 4 /nobreak >nul

echo Zapusk Cloudflare Quick Tunnel...
start "HimBaza Cloudflare Tunnel" cmd /k """%CLOUDFLARED%"" tunnel --protocol http2 --url http://127.0.0.1:5173"

echo.
echo ============================================
echo   Backend:
echo     http://127.0.0.1:8000/docs
echo.
echo   Local production frontend:
echo     http://127.0.0.1:5173/
echo.
echo   LAN production frontend:
echo     http://%LAN_IP%:5173/
echo.
echo   Public URL появится в отдельном окне
echo   HimBaza Cloudflare Tunnel.
echo ============================================
echo.
pause