# Python Alpine Docker Image

![Docker Python](https://raw.githubusercontent.com/ragedunicorn/docker-python/master/docs/docker_python_banner.png)

A minimal Python image on Alpine Linux, shipping a pinned standalone CPython decoupled from the Alpine release.

## Quick Start

```bash
# Pull latest version
docker pull ragedunicorn/python:latest

# Or pull specific version (see the Tags tab for the available versions)
docker pull ragedunicorn/python:<python-major>-alpine<alpine-version>-<build>

# Run Python interactively
docker run -it --rm ragedunicorn/python:latest

# Run a Python script
docker run -v $(pwd):/app ragedunicorn/python:latest script.py
```

On Windows, use the PowerShell form - `${PWD}` **with braces** and the colon
inside the quotes (without braces PowerShell parses `$PWD:` as a
scope-qualified variable, as in `$env:PATH`, and rejects the argument):

```powershell
# Run a Python script
docker run -v "${PWD}:/app" ragedunicorn/python:latest script.py
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

PowerShell:

```powershell
docker run -v "${PWD}:/app" ragedunicorn/python:latest script.py
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
docker run --rm -v $(pwd):/app --entrypoint /bin/sh ragedunicorn/python:latest -c "pip install pytest && python -m pytest"

# Install and use Black formatter
docker run --rm -v $(pwd):/app --entrypoint /bin/sh ragedunicorn/python:latest -c "pip install black && python -m black ."
```

PowerShell - single quotes keep the `sh -c` command one literal argument, so
`&&` runs inside the container:

```powershell
# Install and run pytest
docker run --rm -v "${PWD}:/app" --entrypoint /bin/sh ragedunicorn/python:latest -c 'pip install pytest && python -m pytest'

# Install and use Black formatter
docker run --rm -v "${PWD}:/app" --entrypoint /bin/sh ragedunicorn/python:latest -c 'pip install black && python -m black .'
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

`X` is the Python major version, `A.B.C` the Alpine version:

- `X-alpineA.B.C-1` - Initial release with Python X and Alpine A.B.C
- `X-alpineA.B.C-2` - Rebuild of same versions (bug fixes, security patches)
- `X-alpineA.B.D-1` - Alpine Linux patch update
- `X` - Most recent build of Python X
- `latest` - Most recent stable release

The available versions are listed in the [Tags tab](https://hub.docker.com/r/ragedunicorn/python/tags).

The pinned CPython patch version is fixed per release and updated independently of Alpine. When updates are available through automated dependency management, new releases are created with appropriate version tags.

## Environment Variables

- `PYTHONUNBUFFERED=1` - Unbuffered output

## Working Directory

The default working directory is `/app`. Mount your code here:

```bash
docker run -v $(pwd):/app ragedunicorn/python:latest your_script.py
```

PowerShell:

```powershell
docker run -v "${PWD}:/app" ragedunicorn/python:latest your_script.py
```

## Links

- **GitHub**: [https://github.com/ragedunicorn/docker-python](https://github.com/ragedunicorn/docker-python)
- **Issues**: [https://github.com/ragedunicorn/docker-python/issues](https://github.com/ragedunicorn/docker-python/issues)
- **Releases**: [https://github.com/ragedunicorn/docker-python/releases](https://github.com/ragedunicorn/docker-python/releases)

## License

MIT License - See [GitHub repository](https://github.com/ragedunicorn/docker-python) for details.