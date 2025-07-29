# Python Docker Examples

This directory contains a simple example to get you started with the Python Docker image.

## Hello World Example

The `hello-world.py` script demonstrates basic Python functionality in the Docker container.

### Running the Example

#### Using Docker Compose (recommended)

```bash
# From the examples directory
docker-compose run --rm hello-world

# Or run interactively
docker-compose run --rm python-shell

# Run any Python file
docker-compose run --rm python your-script.py
```

#### Using Docker directly

```bash
# From the repository root
docker run -v $(pwd)/examples:/app ragedunicorn/python:latest hello-world.py
```

### Expected Output

```
Hello, World from Docker Python!
Python version: 3.x.x (main, ...) [GCC ...]
Platform: Linux-...
```

## Creating Your Own Script

1. Create a Python file:

```python
# my-script.py
print("Hello from my custom script!")
```

2. Run it with Docker:

```bash
docker run -v $(pwd):/app ragedunicorn/python:latest my-script.py
```

## Installing Additional Packages

If your script needs additional packages:

```bash
# Install and run in one command
docker run -v $(pwd):/app ragedunicorn/python:latest /bin/sh -c "pip install requests && python my-script.py"
```

Or create a custom Dockerfile:

```dockerfile
FROM ragedunicorn/python:latest

USER root
RUN pip install requests numpy
USER python

WORKDIR /app
COPY . .
CMD ["python", "my-script.py"]
```
