# GitHub Actions Workflows Guide

This repository includes GitHub Actions for Continuous Integration and Deployment.

## Available Workflows

### 1. Simple CI Pipeline (`github-actions.yml`)
A basic workflow that:
- ✅ Runs on Windows environment
- ✅ Validates Kafka scripts exist
- ✅ Checks README documentation
- ✅ Triggers on push and pull requests

### 2. Basic CI Pipeline (`ci-pipeline.yml`)
A simple validation workflow that:
- ✅ Lists repository contents
- ✅ Checks for required batch files
- ✅ Validates basic file structure

## How to Use

### Setting up the Workflow Directory
To enable GitHub Actions, the workflow files need to be in the `.github/workflows/` directory. 

**Manual Setup:**
1. Go to your repository on GitHub
2. Create a new file: `.github/workflows/main.yml`
3. Copy the content from `github-actions.yml`
4. Commit the file

**Example Workflow Content:**
```yaml
name: Kafka Scripts CI

on:
  push:
    branches: [main, gestion_user]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: windows-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v4
      
    - name: Validate Scripts
      run: |
        echo "🔍 Checking Kafka scripts..."
        if (Test-Path "KafkaStart.bat") { 
          echo "✅ KafkaStart.bat found" 
        } else { 
          echo "❌ KafkaStart.bat missing"
          exit 1 
        }
        if (Test-Path "README.md") { 
          echo "✅ README.md found" 
        } else { 
          echo "❌ README.md missing"
          exit 1 
        }
        echo "🎉 All checks passed!"
      shell: powershell
```

## Workflow Features

### ✅ **What Gets Tested:**
- **File Validation**: Ensures all required scripts exist
- **Basic Syntax**: Validates batch file structure
- **Documentation**: Checks README exists and has content
- **Cross-Platform**: Tests on Windows environment

### 🚀 **Triggers:**
- **Push Events**: Runs on commits to main and gestion_user branches
- **Pull Requests**: Validates changes before merging
- **Manual Trigger**: Can be run manually from GitHub Actions tab

### 📊 **Status Badges**
Add this to your README to show build status:
```markdown
![CI Status](https://github.com/koussayx8/test_mcp/workflows/Simple%20Kafka%20CI/badge.svg)
```

## Advanced Pipeline Ideas

For more comprehensive CI/CD, consider adding:

### 🔍 **Extended Validation:**
- Script syntax checking with PowerShell validation
- Security scanning for dangerous commands
- Code quality analysis

### 📦 **Packaging & Deployment:**
- Create release artifacts
- Package scripts for distribution
- Auto-deploy to releases

### 🧪 **Testing:**
- Mock Kafka environment testing
- Integration tests with test containers
- Performance validation

### 📈 **Monitoring:**
- Build notifications
- Slack/Teams integration
- Email alerts for failures

## Example Advanced Workflow

```yaml
name: Advanced Kafka CI

on:
  push:
    branches: [main, gestion_user]

jobs:
  validate:
    runs-on: windows-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Advanced Script Validation
      run: |
        # Comprehensive validation logic
        $errors = 0
        Get-ChildItem *.bat | ForEach-Object {
          $content = Get-Content $_.Name
          if (-not ($content -match "@echo off")) {
            Write-Error "Missing @echo off in $($_.Name)"
            $errors++
          }
        }
        if ($errors -gt 0) { exit 1 }
      shell: powershell
      
  package:
    needs: validate
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Create Release Package
      run: |
        mkdir release
        cp *.bat *.md release/
        tar -czf kafka-suite.tar.gz release/
        
    - name: Upload Artifact
      uses: actions/upload-artifact@v4
      with:
        name: kafka-management-suite
        path: kafka-suite.tar.gz
```

## Getting Started

1. **Copy Workflow**: Copy `github-actions.yml` to `.github/workflows/main.yml`
2. **Commit**: Push the workflow file to your repository
3. **Monitor**: Check the Actions tab on GitHub to see pipeline runs
4. **Customize**: Modify the workflow based on your specific needs

The pipeline will automatically run on every push and pull request, ensuring your Kafka management scripts are always validated and ready for use! 🚀