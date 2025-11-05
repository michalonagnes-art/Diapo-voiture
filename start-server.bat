@echo off
echo Lancement du serveur web local...
echo.
echo Le site sera accessible sur: http://localhost:8000
echo.
echo Appuyez sur Ctrl+C pour arrêter le serveur
echo.
cd /d "%~dp0"
python -m http.server 8000
pause

