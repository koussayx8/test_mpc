@echo off
setlocal enabledelayedexpansion

:: Kafka Status Checker Script
:: Author: Koussay Belhouchet
:: Date: June 28, 2025
:: Description: Check the status of Kafka and Zookeeper services

echo ================================
echo    Kafka Service Status
echo ================================
echo.

:: Set default Kafka installation path
if "%KAFKA_HOME%"=="" (
    set "KAFKA_HOME=C:\kafka\kafka_2.13-3.3.1"
)

echo Kafka Installation: %KAFKA_HOME%
echo Check Time: %date% %time%
echo.

:: Check if Kafka installation exists
if not exist "%KAFKA_HOME%" (
    echo ERROR: Kafka installation directory not found: %KAFKA_HOME%
    echo.
    pause
    exit /b 1
)

:: Initialize status variables
set "zk_running=false"
set "kafka_running=false"
set "zk_pids="
set "kafka_pids="

:: Check for Zookeeper processes
echo Checking Zookeeper status...
tasklist /FI "WINDOWTITLE eq Zookeeper Server*" 2>nul | find /I "cmd.exe" >nul
if %ERRORLEVEL%==0 (
    set "zk_running=true"
    echo ✅ Zookeeper: RUNNING
    
    :: Get Zookeeper PIDs
    for /f "tokens=2" %%i in ('tasklist /FI "WINDOWTITLE eq Zookeeper Server*" /FO CSV ^| find "cmd"') do (
        set "zk_pids=!zk_pids! %%i"
    )
) else (
    echo ❌ Zookeeper: NOT RUNNING
)

:: Check for Kafka Server processes
echo Checking Kafka Server status...
tasklist /FI "WINDOWTITLE eq Kafka Server*" 2>nul | find /I "cmd.exe" >nul
if %ERRORLEVEL%==0 (
    set "kafka_running=true"
    echo ✅ Kafka Server: RUNNING
    
    :: Get Kafka PIDs
    for /f "tokens=2" %%i in ('tasklist /FI "WINDOWTITLE eq Kafka Server*" /FO CSV ^| find "cmd"') do (
        set "kafka_pids=!kafka_pids! %%i"
    )
) else (
    echo ❌ Kafka Server: NOT RUNNING
)

echo.
echo ================================
echo        Detailed Information
echo ================================

:: Check Java processes related to Kafka
echo.
echo Java Processes (Kafka-related):
tasklist /FI "IMAGENAME eq java.exe" 2>nul | find "java.exe" >nul
if %ERRORLEVEL%==0 (
    echo Found Java processes - checking for Kafka/Zookeeper:
    for /f "skip=3 tokens=1,2,5" %%a in ('tasklist /FI "IMAGENAME eq java.exe"') do (
        echo   PID: %%b - Memory: %%c
    )
) else (
    echo No Java processes found.
)

:: Port Status Check
echo.
echo Port Status Check:
echo Checking common Kafka/Zookeeper ports...

:: Check Zookeeper port (2181)
netstat -an | find ":2181" >nul
if %ERRORLEVEL%==0 (
    echo ✅ Port 2181 (Zookeeper): IN USE
) else (
    echo ❌ Port 2181 (Zookeeper): FREE
)

:: Check Kafka port (9092)
netstat -an | find ":9092" >nul
if %ERRORLEVEL%==0 (
    echo ✅ Port 9092 (Kafka): IN USE
) else (
    echo ❌ Port 9092 (Kafka): FREE
)

:: Log file information
echo.
echo Log Files:
if exist "%KAFKA_HOME%\logs" (
    echo Kafka logs directory: %KAFKA_HOME%\logs
    dir "%KAFKA_HOME%\logs" /B /O-D 2>nul | head -5
) else (
    echo No Kafka logs directory found.
)

if exist "logs" (
    echo.
    echo Script logs directory: .\logs
    dir "logs\*.log" /B /O-D 2>nul | head -3
)

:: Summary
echo.
echo ================================
echo            Summary
echo ================================
if "%zk_running%"=="true" AND "%kafka_running%"=="true" (
    echo ✅ Status: Both services are running correctly
    echo 🚀 Kafka cluster is operational
) else if "%zk_running%"=="true" AND "%kafka_running%"=="false" (
    echo ⚠️  Status: Zookeeper running, but Kafka server is down
    echo 💡 Suggestion: Start Kafka server with KafkaStart.bat
) else if "%zk_running%"=="false" AND "%kafka_running%"=="true" (
    echo ⚠️  Status: Kafka running, but Zookeeper is down (unusual)
    echo 💡 Suggestion: Restart both services
) else (
    echo ❌ Status: Both services are stopped
    echo 💡 Suggestion: Start services with KafkaStart.bat
)

echo.
echo Available commands:
echo - Start services: KafkaStart.bat
echo - Stop services: KafkaStop.bat
echo - Check status: KafkaStatus.bat (this script)
echo.

pause