# Python Alpine Docker Image

![Docker Python](https://raw.githubusercontent.com/ragedunicorn/docker-python/master/docs/docker_python.png)

A minimal Python image on Alpine Linux, shipping a pinned standalone CPython decoupled from the Alpine release.

## Quick Start

```bash
# Pull latest version
docker pull ragedunicorn/python:latest

# Or pull specific version
docker pull ragedunicorn/python:3-alpine3.24.0-1

# Run Python interactively
docker run -it --rm ragedunicorn/python:latest

# Run a Python script
docker run -v $(pwd):/app ragedunicorn/python:latest script.py
```

## Features

- 🚀 **Small footprint**: compact runtime image built on Alpine Linux
- 🐍 **Python**: pinned standalone CPython, decoupled from Alpine
- 📦 **Minimal installation**: only Python and pip included
- 🔒 **Security**: non-root user, minimal attack surface
- 🏗️ **Multi-platform**: supports linux/amd64 and linux/arm64
- 🎯 **Customizable**: install only what you need

## Usage Examples

### Run a Python script
```bash
docker run -v $(pwd):/app ragedunicorn/python:latest script.py
```

### Interactive Python shell
```bash
docker run -it --rm ragedunicorn/python:latest
```

### Execute Python code
```bash
docker run --rm ragedunicorn/python:latest -c "print('Hello, World!')"
```

### Install packages and run commands
```bash
# Install and run pytest
docker run -v $(pwd):/app ragedunicorn/python:latest /bin/sh -c "pip install pytest && python -m pytest"

# Install and use Black formatter
docker run -v $(pwd):/app ragedunicorn/python:latest /bin/sh -c "pip install black && python -m black ."
```

### Build a custom image
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

## Tags

This image uses semantic versioning that includes all component versions:

**Format:** `{python_major_version}-alpine{alpine_version}-{build_number}`

### Version Examples

- `3-alpine3.24.0-1` - Initial release with Python 3 and Alpine 3.24.0
- `3-alpine3.24.0-2` - Rebuild of same versions (bug fixes, security patches)
- `3-alpine3.24.1-1` - Alpine Linux patch update
- `latest` - Most recent stable release

The pinned CPython patch version is fixed per release and updated independently of Alpine. When updates are available through automated dependency management, new releases are created with appropriate version tags.

## Environment Variables

- `PYTHONUNBUFFERED=1` - Unbuffered output

## Working Directory

The default working directory is `/app`. Mount your code here:

```bash
docker run -v $(pwd):/app ragedunicorn/python:latest your_script.py
```

## Links

- **GitHub**: [https://github.com/ragedunicorn/docker-python](https://github.com/ragedunicorn/docker-python)
- **Issues**: [https://github.com/ragedunicorn/docker-python/issues](https://github.com/ragedunicorn/docker-python/issues)
- **Releases**: [https://github.com/ragedunicorn/docker-python/releases](https://github.com/ragedunicorn/docker-python/releases)

## License

MIT License - See [GitHub repository](https://github.com/ragedunicorn/docker-python) for details.