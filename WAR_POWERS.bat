@echo off
setlocal enabledelayedexpansion

REM -- Move into this script's own folder --------------------------
REM %~dp0 is the folder this .bat lives in. Doing this FIRST means
REM every command below runs relative to the correct folder, even
REM if the folder name contains spaces.
cd /d "%~dp0"

echo.
echo ==================================================
echo   Executing WAR_POWERS - Windows Launcher
echo ==================================================
echo.

REM -- Request admin rights if not already elevated ---------------
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator rights...
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

REM After elevation the working directory can reset, so set it again.
cd /d "%~dp0"

REM -- Step 1: Check WSL ------------------------------------------
echo [1/4] Checking WSL...
echo.
wsl echo ok >nul 2>&1
if %errorlevel% neq 0 (
    echo   WSL is not installed or not set up.
    echo   Installing now -- Windows will need to restart after this.
    echo.
    pause
    wsl --install
    echo.
    echo ====================================================
    echo   RESTART REQUIRED
    echo   Restart your computer, then run this file again.
    echo ====================================================
    echo.
    pause
    exit /b
)
echo   WSL is ready.

REM -- Step 2: Check / install samtools ---------------------------
echo.
echo [2/4] Checking samtools...
echo.
wsl samtools --version >nul 2>&1
if %errorlevel% neq 0 (
    echo   samtools not found -- installing inside WSL.
    echo   You may be prompted for your Ubuntu password.
    echo.
    wsl bash -c "sudo apt-get update -qq && sudo apt-get install -y samtools"
    if %errorlevel% neq 0 (
        echo.
        echo   ERROR: samtools installation failed.
        echo   Open Ubuntu manually and run:
        echo     sudo apt update
        echo     sudo apt install samtools
        echo   Then run this file again.
        echo.
        pause
        exit /b 1
    )
    echo   samtools installed successfully.
) else (
    echo   samtools already installed.
)

REM -- Step 3: Confirm the bash script is here --------------------
echo.
echo [3/4] Locating WAR_POWERS.sh...
echo.
if not exist "%~dp0WAR_POWERS.sh" (
    echo   ERROR: WAR_POWERS.sh was not found in this folder:
    echo     %~dp0
    echo.
    echo   Make sure WAR_POWERS.sh and your .bam file are in
    echo   the SAME folder as this .bat file, then run it again.
    echo.
    pause
    exit /b 1
)
echo   Found it.

REM -- Step 4: Run the screen -------------------------------------
REM We are already cd'd into this folder, so WSL starts here too and
REM can find the script by its plain name -- no path conversion needed.
echo.
echo   Executing WAR_POWERS...
echo [4/4] Starting deletion screen inside WSL...
echo --------------------------------------------------------
echo.
wsl bash "./WAR_POWERS.sh"

echo.
echo --------------------------------------------------------
echo Finished. Press any key to close.
pause >nul
