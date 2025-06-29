@echo off
setlocal enabledelayedexpansion

:: Enhanced Kafka Startup Script
:: Author: Koussay Belhouchet
:: Date: June 28, 2025
:: Description: Advanced Kafka service management with error handling and configuration options

echo ================================
echo    Kafka Service Manager
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
set "logfile=logs\kafka_startup_%timestamp%.log"

echo %date% %time% - Kafka startup initiated >> "%logfile%"

:: Function to check if Kafka installation exists
echo Validating Kafka installation...
if not exist "%KAFKA_HOME%" (
    echo ERROR: Kafka installation directory not found: %KAFKA_HOME%
    echo Please install Kafka or set KAFKA_HOME environment variable correctly.
    echo %date% %time% - ERROR: Kafka installation not found >> "%logfile%"
    pause
    exit /b 1
)

:: Check for required batch files
if not exist "%KAFKA_HOME%\bin\windows\zookeeper-server-start.bat" (
    echo ERROR: Zookeeper startup script not found.
    echo Expected: %KAFKA_HOME%\bin\windows\zookeeper-server-start.bat
    echo %date% %time% - ERROR: Zookeeper script missing >> "%logfile%"
    pause
    exit /b 1
)

if not exist "%KAFKA_HOME%\bin\windows\kafka-server-start.bat" (
    echo ERROR: Kafka server startup script not found.
    echo Expected: %KAFKA_HOME%\bin\windows\kafka-server-start.bat
    echo %date% %time% - ERROR: Kafka server script missing >> "%logfile%"
    pause
    exit /b 1
)

:: Check for configuration files
if not exist "%KAFKA_HOME%\config\zookeeper.properties" (
    echo ERROR: Zookeeper configuration file not found.
    echo Expected: %KAFKA_HOME%\config\zookeeper.properties
    echo %date% %time% - ERROR: Zookeeper config missing >> "%logfile%"
    pause
    exit /b 1
)

if not exist "%KAFKA_HOME%\config\server.properties" (
    echo ERROR: Kafka server configuration file not found.
    echo Expected: %KAFKA_HOME%\config\server.properties
    echo %date% %time% - ERROR: Kafka server config missing >> "%logfile%"
    pause
    exit /b 1
)

echo All required files found. Proceeding with startup...
echo %date% %time% - Validation successful >> "%logfile%"

:: Check if services are already running
echo Checking for existing Kafka processes...
tasklist /FI "WINDOWTITLE eq Zookeeper*" 2>nul | find /I "cmd.exe" >nul
if %ERRORLEVEL%==0 (
    echo WARNING: Zookeeper appears to be already running.
    echo %date% %time% - WARNING: Zookeeper already running >> "%logfile%"
    set /p continue="Continue anyway? (y/n): "
    if /I "!continue!" NEQ "y" (
        echo Startup cancelled by user.
        echo %date% %time% - Startup cancelled by user >> "%logfile%"
        pause
        exit /b 0
    )
)

:: Start Zookeeper
echo.
echo Starting Zookeeper server...
echo %date% %time% - Starting Zookeeper >> "%logfile%"
start "Zookeeper Server" cmd /k "cd /d %KAFKA_HOME% && bin\windows\zookeeper-server-start.bat config\zookeeper.properties"

:: Wait for Zookeeper to initialize
echo Waiting for Zookeeper to initialize (10 seconds)...
for /L %%i in (10,-1,1) do (
    echo Countdown: %%i seconds remaining...
    timeout /t 1 /nobreak >nul
)

:: Start Kafka Server
echo.
echo Starting Kafka server...
echo %date% %time% - Starting Kafka server >> "%logfile%"
start "Kafka Server" cmd /k "cd /d %KAFKA_HOME% && bin\windows\kafka-server-start.bat config\server.properties"

echo.
echo ================================
echo   Kafka Services Started!
echo ================================
echo.
echo Zookeeper and Kafka servers are starting up...
echo Check the opened command windows for detailed logs.
echo.
echo Log file created: %logfile%
echo.
echo Useful commands:
echo - To stop services: Run KafkaStop.bat (if available)
echo - To check status: Check the opened command windows
echo - To view logs: Check %KAFKA_HOME%\logs directory
echo.
echo %date% %time% - Kafka startup completed successfully >> "%logfile%"

pause