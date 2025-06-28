# test_mcp
Test repository for MCP functionality

## Overview
This repository demonstrates GitHub MCP (Model Context Protocol) integration and contains a comprehensive suite of utilities for Apache Kafka management on Windows systems.

## Kafka Management Scripts

### KafkaStart.bat
An enhanced Windows batch script for starting Apache Kafka services with comprehensive error handling and configuration options.

**Features:**
- ✅ Comprehensive error handling and validation
- ✅ Support for custom Kafka installation paths via `KAFKA_HOME` environment variable
- ✅ Timestamped logging for troubleshooting
- ✅ Process conflict detection (prevents starting duplicate services)
- ✅ Visual countdown timer for proper service initialization
- ✅ Validates all required files before startup
- ✅ Professional formatting and user feedback

**Prerequisites:**
- Apache Kafka installed (default: `C:\kafka\kafka_2.13-3.3.1\`)
- Windows operating system
- Proper Kafka configuration files in place

**Usage:**
1. **Default installation**: Simply run `KafkaStart.bat`
2. **Custom installation**: Set `KAFKA_HOME` environment variable and run the script
3. Two command windows will open - one for Zookeeper, one for Kafka server
4. Check the generated log files in the `logs\` directory for troubleshooting

### KafkaStop.bat
A companion script for gracefully shutting down Kafka and Zookeeper services.

**Features:**
- ✅ Graceful shutdown sequence (Kafka first, then Zookeeper)
- ✅ Support for custom `KAFKA_HOME` environment variable
- ✅ Automatic fallback to manual process termination
- ✅ Timestamped shutdown logging
- ✅ Additional cleanup for remaining Java processes
- ✅ Professional error handling

**Usage:**
Run `KafkaStop.bat` to stop all Kafka services gracefully.

### KafkaStatus.bat
A comprehensive service monitoring script to check the status of Kafka and Zookeeper services.

**Features:**
- ✅ Real-time status checking for both services
- ✅ Process ID and memory usage display
- ✅ Port usage verification (2181 for Zookeeper, 9092 for Kafka)
- ✅ Recent log file information
- ✅ Intelligent status summary with actionable suggestions
- ✅ Professional formatting with visual indicators

**Usage:**
Run `KafkaStatus.bat` to get a comprehensive status report of your Kafka cluster.

## Configuration

### Environment Variables
- **KAFKA_HOME**: Set this to your Kafka installation directory if different from the default
  ```cmd
  set KAFKA_HOME=C:\your\custom\kafka\path
  ```

### Directory Structure
The scripts assume the following directory structure:
```
C:\kafka\kafka_2.13-3.3.1\          (or your KAFKA_HOME)
├── bin\windows\
│   ├── zookeeper-server-start.bat
│   ├── zookeeper-server-stop.bat
│   ├── kafka-server-start.bat
│   └── kafka-server-stop.bat
└── config\
    ├── zookeeper.properties
    └── server.properties
```

### Logging
All scripts create timestamped log files in the `logs\` directory:
- `kafka_startup_YYYY-MM-DD_HH-MM-SS.log` - Startup operations
- `kafka_shutdown_YYYY-MM-DD_HH-MM-SS.log` - Shutdown operations

## Quick Start Guide

1. **First Time Setup:**
   ```cmd
   # Set your Kafka installation path (if not default)
   set KAFKA_HOME=C:\your\kafka\path
   
   # Start services
   KafkaStart.bat
   ```

2. **Daily Operations:**
   ```cmd
   # Check status
   KafkaStatus.bat
   
   # Start services
   KafkaStart.bat
   
   # Stop services
   KafkaStop.bat
   ```

3. **Troubleshooting:**
   - Check the generated log files in `logs\` directory
   - Verify port availability (2181, 9092)
   - Ensure Java is properly installed and accessible

## MCP Integration
This repository was created and managed using GitHub's Model Context Protocol (MCP) integration, demonstrating:
- Repository creation and management
- Branch operations and merging
- File operations (create, update, delete)
- Pull request workflows
- Issue tracking and resolution
- Automated GitHub operations through AI assistance

## Contributing
Feel free to contribute improvements to the Kafka management scripts or add additional utilities. Some ideas for future enhancements:

- Linux/macOS versions of the scripts
- Kafka topic management utilities
- Consumer group monitoring tools
- Performance monitoring scripts
- Docker-based Kafka management

## Support
If you encounter issues:
1. Check the generated log files
2. Verify your Kafka installation
3. Ensure proper Java configuration
4. Create an issue in this repository for assistance

---
*Scripts developed and tested on Windows 10/11 with Apache Kafka 2.13-3.3.1*