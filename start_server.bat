@echo off
title Survey Test Case Tracker - Local Server
cd /d "%~dp0"

echo ============================================
echo   Dang khoi dong local server tai cong 8080
echo   Thu muc: %cd%
echo ============================================
echo.
echo Trinh duyet se tu mo sau vai giay:
echo   http://localhost:8080/NewTC2.html
echo.
echo De DUNG server: quay lai cua so nay va nhan Ctrl + C
echo ============================================
echo.

REM Mo trinh duyet sau 2 giay (chay nen, khong lam cho server)
start "" /min powershell -NoProfile -Command "Start-Sleep -Seconds 2; Start-Process 'http://localhost:8080/NewTC2.html'"

REM Chay server (giu cua so nay mo, Ctrl+C de dung)
python -m http.server 8080

pause
