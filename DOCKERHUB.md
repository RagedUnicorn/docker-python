# Python Docker Image

Minimal Python Docker image built on Alpine Linux.

## Quick Start

```bash
docker pull ragedunicorn/python:latest
docker run -it --rm ragedunicorn/python:latest
```

## Features

- 🐍 **Python 3.14.6** - pinned standalone CPython
- 🏔️ **Alpine Linux** - Minimal base image
- 📦 **Minimal installation** - Only Python and pip included
- 🔒 **Security** - Non-root user, minimal attack surface
- 🚀 **Multi-architecture** - Supports amd64 and arm64
- 🎯 **Customizable** - Install only what you need

## Available Tags

- `latest` - Most recent stable release
- `v3-alpine3.24.0-1` - Python 3.14.6 on Alpine 3.24.0, build 1
- `v3.14.6` - Specific Python version tag
- `v3.14` - Python minor version tag

## Usage Examples

### Run a Python script
```bash
docker run -v $(pwd):/app ragedunicorn/python:latest script.py
```

### Interactive Python shell
```bash
docker run -it ragedunicorn/python:latest
```

### Install packages and run commands
```bash
# Install and run pytest
docker run -v $(pwd):/app ragedunicorn/python:latest /bin/sh -c "pip install pytest && python -m pytest"

# Install and use Black formatter
docker run -v $(pwd):/app ragedunicorn/python:latest /bin/sh -c "pip install black && python -m black ."
```

## Base Installation

This image includes only:
- Python 3.14.6 (pinned standalone CPython from python-build-standalone)
- pip (Python package installer)

No additional packages are pre-installed, keeping the image minimal and allowing you to install only what you need.

## Environment Variables

- `PYTHONUNBUFFERED=1` - Unbuffered output

## Working Directory

The default working directory is `/app`. Mount your code here:

```bash
docker run -v $(pwd):/app ragedunicorn/python:latest your_script.py
```

## Building Custom Images

Create your own image with additional packages:

```dockerfile
FROM ragedunicorn/python:latest

# Install additional packages
USER root
RUN pip install django flask fastapi
USER python

# Your custom configuration
WORKDIR /app
COPY . .
CMD ["python", "app.py"]
```

## Links

- [GitHub Repository](https://github.com/ragedunicorn/docker-python)
- [Documentation](https://github.com/ragedunicorn/docker-python/blob/master/README.md)
- [Issues](https://github.com/ragedunicorn/docker-python/issues)

## License

MIT License - see [LICENSE](https://github.com/ragedunicorn/docker-python/blob/master/LICENSE.txt)
