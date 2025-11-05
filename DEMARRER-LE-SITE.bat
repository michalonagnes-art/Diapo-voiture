@echo off
title LuxeWatch - Serveur Local
color 0A
echo.
echo ==========================================
echo    SERVEUR WEB LOCAL - LUXEWATCH
echo ==========================================
echo.
echo Lancement du serveur...
echo.
echo Le site sera accessible sur: http://localhost:8000
echo.
echo Appuyez sur Ctrl+C pour arreter le serveur
echo.
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File "%~dp0start-server.ps1"
pause

