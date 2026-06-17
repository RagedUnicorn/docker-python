# Testing Guide

This document describes how to test the Python Docker image using Container Structure Tests.

## Quick Start

```bash
# Run all tests
docker compose -f docker-compose.test.yml run test-all

# Run individual test suites
docker compose -f docker-compose.test.yml up container-test          # File structure tests
docker compose -f docker-compose.test.yml up container-test-command  # Command execution tests
docker compose -f docker-compose.test.yml up container-test-metadata # Metadata validation tests
```

## Test Structure

The test suite consists of three main test files:

### 1. File Structure Tests (`test/python_test.yml`)

Validates:

- Python and pip binaries exist with correct permissions
- Working directory `/app` exists and is accessible
- Python standard library is installed
- SSL certificates are present for pip functionality

### 2. Command Execution Tests (`test/python_command_test.yml`)

Validates:

- Python and pip version outputs
- Basic Python code execution
- Standard library imports (sys, os, json)
- Script execution capability
- Non-root user functionality
- Working directory configuration

### 3. Metadata Tests (`test/python_metadata_test.yml`)

Validates:

- OCI-compliant labels are present and correct
- Container entrypoint and default command
- Working directory configuration
- User context (runs as non-root python user)

## Running Tests

### Prerequisites

1. Docker must be installed and running
2. Build the Python image locally before testing

### Important: Always Test Local Builds

**⚠️ Always build and test locally to ensure consistency:**

```bash
# Build the image locally with a test tag
docker build -t ragedunicorn/python:test .
```

**Linux/macOS:**

```bash
# Run tests against your local build
PYTHON_VERSION=test docker compose -f docker-compose.test.yml run test-all
```

**Windows (PowerShell):**

```powershell
# Run tests against your local build
$env:PYTHON_VERSION="test"; docker compose -f docker-compose.test.yml run test-all
```

**Windows (Command Prompt):**

```cmd
# Run tests against your local build
set PYTHON_VERSION=test && docker compose -f docker-compose.test.yml run test-all
```

**Why local testing is important:**
- Remote images (Docker Hub, GHCR) may have different labels due to CI/CD overrides
- Ensures you're testing exactly what you built
- Avoids false positives/negatives from version mismatches
- Guarantees consistent test results

**Never pull remote images for testing:**

**❌ DON'T DO THIS - may have different labels/settings:**

```bash
docker pull ragedunicorn/python:latest
docker compose -f docker-compose.test.yml run test-all
```

**✅ DO THIS - test your local build:**

Linux/macOS:

```bash
docker build -t ragedunicorn/python:test .
PYTHON_VERSION=test docker compose -f docker-compose.test.yml run test-all
```

Windows (PowerShell):

```powershell
docker build -t ragedunicorn/python:test .
$env:PYTHON_VERSION="test"; docker compose -f docker-compose.test.yml run test-all
```

### Test Execution

Run all tests against your local build:

**Linux/macOS:**

```bash
# Ensure you've built locally first!
PYTHON_VERSION=test docker compose -f docker-compose.test.yml run test-all
```

**Windows (PowerShell):**

```powershell
# Ensure you've built locally first!
$env:PYTHON_VERSION="test"; docker compose -f docker-compose.test.yml run test-all
```

**Windows (Command Prompt):**

```cmd
# Ensure you've built locally first!
set PYTHON_VERSION=test && docker compose -f docker-compose.test.yml run test-all
```

Run specific test categories:

**Linux/macOS:**

```bash
# File structure and library tests
PYTHON_VERSION=test docker compose -f docker-compose.test.yml up container-test

# Command execution and functionality tests
PYTHON_VERSION=test docker compose -f docker-compose.test.yml up container-test-command

# Metadata and label tests
PYTHON_VERSION=test docker compose -f docker-compose.test.yml up container-test-metadata
```

**Windows (PowerShell):**

```powershell
# File structure and library tests
$env:PYTHON_VERSION="test"; docker compose -f docker-compose.test.yml up container-test

# Command execution and functionality tests
$env:PYTHON_VERSION="test"; docker compose -f docker-compose.test.yml up container-test-command

# Metadata and label tests
$env:PYTHON_VERSION="test"; docker compose -f docker-compose.test.yml up container-test-metadata
```

### Testing Different Versions

When testing different versions, always build locally first:

```bash
# Build a specific version locally
docker build -t ragedunicorn/python:3-alpine3.24.0-1 .
```

**Linux/macOS:**

```bash
# Test that specific version
PYTHON_VERSION=3-alpine3.24.0-1 docker compose -f docker-compose.test.yml run test-all
```

**Windows (PowerShell):**

```powershell
# Test that specific version
$env:PYTHON_VERSION="3-alpine3.24.0-1"; docker compose -f docker-compose.test.yml run test-all
```

## Troubleshooting Test Failures

### Python Version / Path Mismatches

The interpreter is a pinned standalone CPython under `/opt/python`. When the pinned `PYTHON_VERSION` changes minor (e.g. 3.14 → 3.15), the version-specific paths in `test/python_test.yml` (`/opt/python/lib/python3.X`) and the expected output in `test/python_command_test.yml` (`Python 3.X`) must be updated to match.

To find the current Python installation details in the image:

```bash
docker run --rm --entrypoint sh ragedunicorn/python:latest -c \
  "ls -la /opt/python/bin/python* && ls -la /opt/python/lib"
```

### Binary Layout

`/opt/python/bin` contains `python3`, the `python` entrypoint, and `pip`/`pip3`. The file
existence tests assert these paths exist rather than asserting exact permission modes (symlink
vs. regular file varies between standalone CPython releases):

```bash
# Inspect the interpreter binaries
docker run --rm --entrypoint sh ragedunicorn/python:test -c "ls -la /opt/python/bin/python*"
```

### Metadata Test Failures

**Common causes:**

1. **Testing remote images instead of local builds**
   - Remote images (Docker Hub, GHCR) have labels overridden by CI/CD
   - Always test your local builds with `PYTHON_VERSION=test`

2. **Label value mismatches**
   - CI/CD systems may capitalize values (e.g., "RagedUnicorn" vs "ragedunicorn")
   - GitHub Actions may override labels during build
   - Docker Hub automated builds may set different values

3. **Version-specific labels**
   - The `org.opencontainers.image.version` label changes with each build
   - Build date labels are dynamic

**Solution:** Always build and test locally before pushing:

```bash
docker build -t ragedunicorn/python:test .
```

Linux/macOS:

```bash
PYTHON_VERSION=test docker compose -f docker-compose.test.yml run test-all
```

Windows (PowerShell):

```powershell
$env:PYTHON_VERSION="test"; docker compose -f docker-compose.test.yml run test-all
```

### Permission Errors

If you encounter Docker socket permission errors:

```bash
sudo docker compose -f docker-compose.test.yml run test-all
```

Or ensure your user is in the `docker` group:

```bash
sudo usermod -aG docker $USER
# Log out and back in for changes to take effect
```

## Writing New Tests

To add new tests, follow the Container Structure Test schema:

1. **File tests**: Add to `test/python_test.yml`
2. **Command tests**: Add to `test/python_command_test.yml`
3. **Metadata tests**: Add to `test/python_metadata_test.yml`

Example of adding a new package test:

```yaml
- name: 'Check pip package installation'
  command: 'pip'
  args: ['install', 'requests']
  exitCode: 0
```

## CI/CD Integration

These tests are automatically run in GitHub Actions:

- **On every push** to master branches
- **On every pull request** to master branches
- **Before releases** to ensure quality

The test workflow (`.github/workflows/test.yml`):
1. Builds the Docker image
2. Runs all Container Structure Tests
3. Verifies basic Python functionality
4. Blocks releases if tests fail

Manual integration example:

```yaml
- name: Run Container Structure Tests
  env:
    PYTHON_VERSION: test
  run: docker compose -f docker-compose.test.yml run test-all
```

The `test-all` service returns:
- Exit code 0: All tests passed
- Exit code 1: One or more tests failed

## Test Maintenance

When updating the Docker image:

1. **Python version updates**: A minor bump (3.X → 3.Y) requires updating the `/opt/python/lib/python3.X` paths in `python_test.yml` and the `Python 3.X` output in `python_command_test.yml`; patch bumps need no test changes
2. **Alpine version updates**: Renovate keeps the `base.name` label and `python_metadata_test.yml` in sync with the `FROM` version, so no manual edit is needed for the drift to resolve
3. **New functionality**: Add corresponding tests to verify behavior
4. **Label changes**: Update metadata tests to match new labels

Always run the full test suite before creating a release.