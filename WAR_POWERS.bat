@echo off
cd /d "%~dp0"
echo ==================================================
echo   Executing WAR_POWERS  (v2.8)
echo ==================================================
echo.
wsl -e bash -lc "command -v samtools >/dev/null 2>&1 || { echo Installing samtools...; sudo apt-get update -qq && sudo apt-get install -y samtools; }; bash WAR_POWERS.sh; echo; echo ===== FINISHED - review output above ====="
echo.
echo Press any key to close this window.
pause >nul
