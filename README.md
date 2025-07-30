# docker-python

![](./docs/docker_python.png)

[![Release Build](https://github.com/ragedunicorn/docker-python/actions/workflows/docker_release.yml/badge.svg)](https://github.com/ragedunicorn/docker-python/actions/workflows/docker_release.yml)
[![Test](https://github.com/ragedunicorn/docker-python/actions/workflows/test.yml/badge.svg)](https://github.com/ragedunicorn/docker-python/actions/workflows/test.yml)
![License: MIT](docs/license_badge.svg)

> Docker Alpine image with Python and pip.

![](./docs/alpine_linux_logo.svg)

## Overview

This Docker image provides a minimal Python installation built on Alpine Linux. It includes only Python and pip, allowing you to install exactly what you need for your specific use case.

## Features

- **Small footprint**: ~50MB runtime image using Alpine Linux
- **Python 3**: Latest Python 3 version from Alpine packages
- **Minimal installation**: Only Python and pip included
- **Non-root user**: Enhanced security with dedicated python user
- **Volume mounting**: Easy code and data access through `/app`

## Quick Start

```bash
# Pull the image
docker pull ragedunicorn/python:latest

# Run Python interactively
docker run -it --rm ragedunicorn/python:latest
```

For development and building from source, see [DEVELOPMENT.md](DEVELOPMENT.md).

## Usage

The container uses Python as the entrypoint, so any Python parameters can be passed directly to the `docker run` command.

### Basic Usage

```bash
# Using latest version
docker run -v $(pwd):/app ragedunicorn/python:latest [python-options]

# Using specific Python version (latest Alpine build)
docker run -v $(pwd):/app ragedunicorn/python:3 [python-options]

# Using exact version combination
docker run -v $(pwd):/app ragedunicorn/python:3-alpine3.22.1-1 [python-options]
```

### Examples

#### Run Python Script
```bash
docker run -v $(pwd):/app ragedunicorn/python:latest script.py
```

#### Interactive Python Shell
```bash
docker run -it --rm ragedunicorn/python:latest
```

#### Execute Python Code
```bash
docker run --rm ragedunicorn/python:latest -c "print('Hello, World!')"
```

#### Install Package and Run
```bash
docker run -v $(pwd):/app ragedunicorn/python:latest /bin/sh -c "pip install requests && python script.py"
```

#### Check Python Version
```bash
docker run --rm ragedunicorn/python:latest --version
```

#### Run Tests
```bash
docker run -v $(pwd):/app ragedunicorn/python:latest /bin/sh -c "pip install pytest && python -m pytest"
```

## Docker Compose Usage

This repository includes Docker Compose configurations for easier usage and common Python development workflows.

### Basic Setup

1. Create an `app` directory:
```bash
mkdir -p app
```

2. Place your Python files in `app/`

3. Run Python using docker compose:
```bash
docker compose run --rm python script.py
```

### Example Configuration

The `examples/` directory contains a hello-world example:

#### Hello World Example (`examples/docker-compose.yml`)
```bash
# Run the hello world example
cd examples && docker compose run --rm hello-world
```

### Environment Variables

The compose configuration supports:

- `PYTHON_VERSION`: Specify Python image version (default: latest)
- `PYTHONUNBUFFERED`: Unbuffered output (set to 1)
- `TERM`: Terminal type for colored output

### Tips

1. **Custom Commands**: Override the default command:
   ```bash
   docker compose run --rm python -c "import sys; print(sys.version)"
   ```

2. **Development Mode**: Use the development compose file for building locally:
   ```bash
   docker compose -f docker-compose.dev.yml build
   docker compose -f docker-compose.dev.yml run --rm python script.py
   ```

3. **Persistent Settings**: The repository includes a `.env` file with default settings:
   ```env
   PYTHON_VERSION=latest
   ```

## Building Custom Images

To create a custom image with your required packages:

```dockerfile
FROM ragedunicorn/python:latest

# Install Python packages
USER root
RUN pip install requests numpy pandas
USER python

# Copy your application
WORKDIR /app
COPY . .

CMD ["python", "app.py"]
```

## Versioning

This project uses semantic versioning that matches the Docker image contents:

**Format:** `{python_major_version}-alpine{alpine_version}-{build_number}`

Examples:
- `3-alpine3.22.1-1` - Python 3 on Alpine 3.22.1, build 1
- `latest` - Most recent stable release

For detailed release process and versioning guidelines, see [RELEASE.md](RELEASE.md).

## Automated Dependency Updates

This project uses [Renovate](https://docs.renovatebot.com/) to automatically check for updates to:
- Alpine Linux base image version (all major, minor, and patch updates)

Renovate runs weekly (every Monday) and creates pull requests when updates are available. The configuration tracks Alpine Linux releases, creating pull requests for each update.

## Documentation

- [Development Guide](DEVELOPMENT.md) - Building, debugging, and contributing
- [Testing Guide](TEST.md) - Running and writing tests
- [Release Process](RELEASE.md) - Creating releases and versioning

## Links

- [Python Documentation](https://docs.python.org/)
- [Alpine Linux](https://www.alpinelinux.org/)

# License

MIT License

Copyright (c) 2025 Michael Wiesendanger

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
