# Development Guide

This document provides information for developers working on the Python Docker image.

## Development Environment

### Prerequisites

- Docker installed and running
- Docker Compose installed
- Git for version control
- Text editor or IDE

### Project Structure

```
docker-python/
├── Dockerfile              # Main image definition
├── docker-compose.yml      # Basic usage configuration
├── docker-compose.dev.yml  # Development environment
├── docker-compose.test.yml # Test orchestration
├── .env                    # Default environment variables
├── examples/               # Example Docker Compose configurations
│   └── docker-compose.yml  # Hello world example
├── test/                   # Container Structure Tests
│   ├── python_test.yml
│   ├── python_command_test.yml
│   └── python_metadata_test.yml
└── docs/                   # Documentation assets
```

## Development Workflow

### 1. Local Development Mode

The `docker-compose.dev.yml` file provides an interactive development environment:

```bash
# Build the image locally
docker compose -f docker-compose.dev.yml build

# Run in development mode (interactive Python shell)
docker compose -f docker-compose.dev.yml run --rm python

# Inside the container, you can run Python manually
docker compose -f docker-compose.dev.yml run --rm python -c "print('Hello from dev!')"
docker compose -f docker-compose.dev.yml run --rm python script.py
```

The development mode:

- Mounts the current directory to `/app` for testing files
- Uses interactive mode with STDIN open and TTY allocated
- Sets Python environment variables for optimal development

### 2. Building the Image

```bash
# Basic build
docker build -t ragedunicorn/python:dev .

# Build with specific versions
docker build \
  --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
  --build-arg VERSION=3-alpine3.22.1-1 \
  -t ragedunicorn/python:3-alpine3.22.1-1 .

# Multi-platform build (requires buildx)
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t ragedunicorn/python:dev .
```

### 3. Testing Your Changes

After making changes, always build and test locally:

```bash
# Build your changes locally
docker build -t ragedunicorn/python:test .
```

#### Running Tests (Cross-Platform)

**Linux/macOS:**

```bash
# Run all tests against your local build
PYTHON_VERSION=test docker compose -f docker-compose.test.yml run test-all

# Run specific tests during development
PYTHON_VERSION=test docker compose -f docker-compose.test.yml up container-test-command
```

**Windows Command Prompt:**

```cmd
# Run all tests against your local build
set PYTHON_VERSION=test && docker compose -f docker-compose.test.yml run test-all

# Run specific tests during development
set PYTHON_VERSION=test && docker compose -f docker-compose.test.yml up container-test-command
```

**Windows PowerShell:**

```powershell
# Run all tests against your local build
$env:PYTHON_VERSION="test"; docker compose -f docker-compose.test.yml run test-all

# Run specific tests during development
$env:PYTHON_VERSION="test"; docker compose -f docker-compose.test.yml up container-test-command
```

**Important:** Never test against remote images - they may have different labels or configurations due to CI/CD overrides.

See [TEST.md](TEST.md) for detailed testing information.

## Making Changes

### Version Updates

This project uses [Renovate](https://docs.renovatebot.com/) to automatically manage dependency updates:

- **Alpine Linux**: Renovate monitors Docker Hub and creates PRs for new Alpine versions

When Renovate creates a PR:

1. Review the changes in the PR
2. Check the CI/CD pipeline passes all tests
3. Test the build locally if it's a major version update
4. Merge the PR if everything looks good

Manual version updates are rarely needed, but if required:

```dockerfile
# Alpine base image
FROM alpine:3.22.1
```

When manually updating versions:

1. Update the `FROM alpine:X.X.X` line in the Dockerfile
2. Test the build thoroughly - Python package versions may have changed
3. Update library versions in `test/python_test.yml` if needed
4. Update version numbers in documentation

### Adding Python Packages

To add packages to the base image (discouraged - users should extend the image):

```dockerfile
# Add after the pip installation
RUN apk add --no-cache \
    python3 \
    py3-pip \
    your-new-package  # Add here
```

**Note:** This image is intentionally minimal. Users should extend it:

```dockerfile
FROM ragedunicorn/python:latest
RUN pip install requests numpy pandas
```

## Code Style and Best Practices

### Dockerfile Best Practices

1. **Minimal installation**: Only Python and pip included
2. **Layer optimization**: Group related commands to minimize layers
3. **Cache efficiency**: Order commands from least to most frequently changed
4. **Security**: Run as non-root user
5. **Labels**: Follow OCI naming conventions

### Documentation

1. **README.md**: Keep focused on user-facing information
2. **Comments**: Add comments in Dockerfile for complex operations
3. **Examples**: Provide working examples for new features
4. **Commit messages**: Use conventional format (feat:, fix:, docs:, etc.)

### Testing

1. **Test everything**: New features must include tests
2. **Test edge cases**: Include negative tests where appropriate
3. **Keep tests fast**: Avoid long-running operations in tests
4. **Test organization**: Group related tests together

## Debugging

### Common Issues

**Build failures:**

```bash
# Verbose build output
docker build --progress=plain --no-cache -t ragedunicorn/python:debug .

# Check Alpine package availability
docker run --rm alpine:3.22.1 apk search python3
```

**Python not working:**

```bash
# Check Python installation
docker run --rm --entrypoint sh ragedunicorn/python:dev -c "which python"
docker run --rm --entrypoint sh ragedunicorn/python:dev -c "python --version"

# Check pip installation
docker run --rm --entrypoint sh ragedunicorn/python:dev -c "pip --version"
```

**Package installation issues:**

```bash
# Check available packages
docker run --rm --entrypoint sh ragedunicorn/python:dev -c "apk search py3-"

# Test package installation
docker run --rm --entrypoint sh ragedunicorn/python:dev -c "pip install requests"
```

## Contributing

### Before Submitting Changes

1. Run the full test suite
2. Update documentation if needed
3. Add tests for new features
4. Ensure your code follows the existing style
5. Write clear commit messages

### Pull Request Process

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes using conventional commits
4. Push to your fork
5. Open a Pull Request with a clear description

### Release Process

See [RELEASE.md](RELEASE.md) for information about creating releases.
