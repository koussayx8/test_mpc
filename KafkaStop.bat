@echo off
setlocal enabledelayedexpansion

:: Kafka Stop Script
:: Author: Koussay Belhouchet
:: Date: June 28, 2025
:: Description: Gracefully stop Kafka and Zookeeper services

echo ================================
echo    Kafka Service Stopper
echo ================================
echo.

:: Set default Kafka installation path (can be overridden by environment variable)
if "%KAFKA_HOME%"=="" (
    set "KAFKA_HOME=C:\kafka\kafka_2.13-3.3.1"
    echo Using default Kafka installation: !KAFKA_HOME!
) else (
    echo Using custom Kafka installation: %KAFKA_HOME%
)

:: Create logs directory if it doesn't exist
if not exist "logs" mkdir logs

:: Set log file with timestamp
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "timestamp=%dt:~0,4%-%dt:~4,2%-%dt:~6,2%_%dt:~8,2%-%dt:~10,2%-%dt:~12,2%"
set "logfile=logs\kafka_shutdown_%timestamp%.log"

echo %date% %time% - Kafka shutdown initiated >> "%logfile%"

:: Check if Kafka installation exists
if not exist "%KAFKA_HOME%" (
    echo ERROR: Kafka installation directory not found: %KAFKA_HOME%
    echo %date% %time% - ERROR: Kafka installation not found >> "%logfile%"
    pause
    exit /b 1
)

:: Check for stop scripts
if not exist "%KAFKA_HOME%\bin\windows\kafka-server-stop.bat" (
    echo WARNING: Kafka server stop script not found.
    echo Will attempt to stop processes manually.
    echo %date% %time% - WARNING: Kafka stop script missing >> "%logfile%"
    set "manual_stop=true"
) else (
    set "manual_stop=false"
)

if not exist "%KAFKA_HOME%\bin\windows\zookeeper-server-stop.bat" (
    echo WARNING: Zookeeper stop script not found.
    echo Will attempt to stop processes manually.
    echo %date% %time% - WARNING: Zookeeper stop script missing >> "%logfile%"
    set "manual_zk_stop=true"
) else (
    set "manual_zk_stop=false"
)

:: Stop Kafka Server first
echo Stopping Kafka server...
echo %date% %time% - Stopping Kafka server >> "%logfile%"

if "%manual_stop%"=="false" (
    cd /d "%KAFKA_HOME%"
    call bin\windows\kafka-server-stop.bat
    echo Kafka server stop command executed.
) else (
    echo Attempting to stop Kafka server processes manually...
    taskkill /F /FI "WINDOWTITLE eq Kafka Server*" 2>nul
    if %ERRORLEVEL%==0 (
        echo Kafka server processes terminated.
    ) else (
        echo No Kafka server processes found or failed to terminate.
    )
)

:: Wait a moment before stopping Zookeeper
echo Waiting 5 seconds before stopping Zookeeper...
timeout /t 5 /nobreak >nul

:: Stop Zookeeper
echo Stopping Zookeeper server...
echo %date% %time% - Stopping Zookeeper server >> "%logfile%"

if "%manual_zk_stop%"=="false" (
    cd /d "%KAFKA_HOME%"
    call bin\windows\zookeeper-server-stop.bat
    echo Zookeeper stop command executed.
) else (
    echo Attempting to stop Zookeeper processes manually...
    taskkill /F /FI "WINDOWTITLE eq Zookeeper Server*" 2>nul
    if %ERRORLEVEL%==0 (
        echo Zookeeper processes terminated.
    ) else (
        echo No Zookeeper processes found or failed to terminate.
    )
)

:: Additional cleanup - force kill any remaining java processes related to Kafka
echo.
echo Performing additional cleanup...
tasklist /FI "IMAGENAME eq java.exe" | find "kafka" >nul 2>&1
if %ERRORLEVEL%==0 (
    echo Found remaining Kafka-related Java processes. Attempting to terminate...
    for /f "tokens=2" %%i in ('tasklist /FI "IMAGENAME eq java.exe" /FO CSV ^| find "kafka"') do (
        taskkill /F /PID %%i >nul 2>&1
    )
)

echo.
echo ================================
echo   Kafka Services Stopped!
echo ================================
echo.
echo Kafka and Zookeeper services have been stopped.
echo Check the log file for details: %logfile%
echo.
echo %date% %time% - Kafka shutdown completed >> "%logfile%"

pause