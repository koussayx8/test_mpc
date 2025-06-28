# test_mpc
Test repository for MCP functionality

## Overview
This repository demonstrates GitHub MCP (Model Context Protocol) integration and contains utilities for Apache Kafka management.

## Files

### KafkaStart.bat
A Windows batch script for starting Apache Kafka services.

**What it does:**
- Starts Zookeeper server in a new command window
- Waits 5 seconds for Zookeeper to initialize properly
- Starts Kafka server in another command window

**Prerequisites:**
- Apache Kafka installed at `C:\kafka\kafka_2.13-3.3.1\`
- Windows operating system
- Proper Kafka configuration files in place

**Usage:**
1. Ensure Kafka is installed in the expected directory
2. Run the script: `KafkaStart.bat`
3. Two command windows will open - one for Zookeeper, one for Kafka server

**Configuration:**
The script assumes the following directory structure:
```
C:\kafka\kafka_2.13-3.3.1\
├── bin\windows\
│   ├── zookeeper-server-start.bat
│   └── kafka-server-start.bat
└── config\
    ├── zookeeper.properties
    └── server.properties
```

## MCP Integration
This repository was created and managed using GitHub's Model Context Protocol (MCP) integration, demonstrating:
- Repository creation
- Branch management
- File operations
- Pull request workflows
- Automated GitHub operations through AI assistance

## Contributing
Feel free to contribute improvements to the Kafka startup script or add additional utilities for Kafka management.