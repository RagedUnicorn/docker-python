# Release Process

This document describes how to create a new release for the Docker Python project.

## Quick Start

```bash
# Tag format: v{python_major_version}-alpine{alpine_version}-{build_number}
# Take the versions from the Dockerfile (the PYTHON_VERSION major and the FROM line)
TAG=v<python-major>-alpine<alpine-version>-<build>
git tag -a "$TAG" -m "$TAG"
git push origin "$TAG"
```

This automatically triggers the release process via GitHub Actions.

## Version Tag Format

See [README.md](README.md#versioning) for the complete versioning documentation.

**Format:** `v{python_major_version}-alpine{alpine_version}-{build_number}`

Examples (`X` is the Python major version, `A.B.C` the Alpine version):
- `vX-alpineA.B.C-1` - Initial release
- `vX-alpineA.B.C-2` - Rebuild with same versions
- `vX-alpineA.B.D-1` - Alpine update (build resets to 1)
- `vX-alpineA.B+1.0-1` - Alpine minor update (build resets to 1)

## Release Workflow

When you push a tag, GitHub Actions automatically:

1. **Builds Docker images** (`.github/workflows/docker_release.yml`)
   - Multi-platform: linux/amd64 and linux/arm64
   - Pushes to both GitHub Container Registry and Docker Hub
   - Attaches SBOM and provenance (`mode=max`) attestations
   - Signs the pushed digest in both registries with cosign keyless signing (GitHub OIDC)

2. **Creates GitHub Release** (`create-release` job in `.github/workflows/docker_release.yml`)
   - Runs only after the images were tested and pushed successfully
   - Generates changelog from commit history
   - Adds Docker pull commands
   - Links to the release

## When to Create a Release

Create a new release when:

1. **Renovate updates dependencies** - After merging Renovate PRs for Alpine updates
2. **Bug fixes** - After fixing issues in the Dockerfile or build process
3. **Feature additions** - After adding new functionality
4. **Security patches** - Immediately after security-related updates

### Build Number Guidelines

- **Reset to 1**: When Alpine version changes
- **Increment**: When rebuilding with the same versions (fixes, optimizations)

## Post-Release Tasks

### Update Docker Hub Documentation

`DOCKERHUB.md` is the source of truth for the Docker Hub repository
description. It deliberately contains no concrete versions (readers find those
in the Tags tab), so a release alone does not require a description update.
Only when `DOCKERHUB.md` changed since the last sync:

1. Go to [Docker Hub](https://hub.docker.com/r/ragedunicorn/python)
2. Click "Manage Repository" → "Description"
3. Copy the contents of `DOCKERHUB.md`
4. Save the changes

**Note**: the sync stays manual on purpose. Docker Hub only offers an
undocumented endpoint for description updates, and it needs a separate
Read/Write/Delete access token.

## Best Practices

### Commit Messages

Use conventional commit format for better changelogs:

- `feat:` New features
- `fix:` Bug fixes
- `docs:` Documentation changes
- `chore:` Maintenance tasks
- `refactor:` Code refactoring
- `test:` Test additions/changes
- `perf:` Performance improvements

Example:
```bash
git commit -m "feat: add support for additional Python packages"
git commit -m "fix: resolve permission issue in container"
git commit -m "docs: update usage examples"
```

### Pre-release Testing

Before creating a release:

1. Test the Docker image locally with your version changes
2. Verify Python runs correctly with test scripts
3. Check that multi-platform builds work (especially arm64)

## Troubleshooting

### Release didn't trigger

- Ensure tag starts with `v` and follows the format (e.g., `vX-alpineA.B.C-N`)
- Check GitHub Actions tab for workflow runs
- Verify you have push permissions

### Docker build failed

- Check the Docker workflow logs
- Ensure Dockerfile builds locally
- Verify multi-platform compatibility

### Missing permissions

Ensure your repository has:
- GitHub Actions enabled
- Package write permissions for workflows
- Proper secrets configuration (GITHUB_TOKEN is automatic)

### Docker Hub Configuration

To enable Docker Hub deployment, you need to add these secrets to your GitHub repository:

1. Go to Settings → Secrets and variables → Actions
2. Add the following secrets:
   - `DOCKERHUB_USERNAME`: Your Docker Hub username
   - `DOCKERHUB_TOKEN`: Your Docker Hub access token (not password)

To create a Docker Hub access token:
1. Log in to Docker Hub
2. Go to Account Settings → Security
3. Click "New Access Token"
4. Give it a descriptive name (e.g., "GitHub Actions")
5. Copy the token and add it as `DOCKERHUB_TOKEN` secret

## Manual Release (if needed)

If automation fails, you can create a release manually:

1. Go to repository's "Releases" page
2. Click "Create a new release"
3. Choose your tag (must follow format: `vX-alpineA.B.C-N`)
4. Add release notes
5. Include Docker pull commands (the tag without the leading `v`):
   ```
   docker pull ghcr.io/ragedunicorn/docker-python:<tag>
   docker pull ragedunicorn/python:<tag>
   ```