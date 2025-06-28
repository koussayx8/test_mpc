@echo off
start cmd /k "cd /d C:\kafka\kafka_2.13-3.3.1 && bin\windows\zookeeper-server-start.bat config\zookeeper.properties"
timeout /t 5
start cmd /k "cd /d C:\kafka\kafka_2.13-3.3.1 && bin\windows\kafka-server-start.bat config\server.properties"