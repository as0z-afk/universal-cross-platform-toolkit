@echo off
setlocal
cd /d "%~dp0"
python -m ubtoolkit %*
exit /b %ERRORLEVEL%
