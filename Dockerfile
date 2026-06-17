############################################
# Download + verify stage
############################################
FROM alpine:3.24.0 AS build

# renovate: datasource=docker depName=python versioning=docker
ARG PYTHON_VERSION=3.14.6
# renovate: datasource=github-releases depName=astral-sh/python-build-standalone versioning=regex:^(?<major>\d{4})(?<minor>\d{2})(?<patch>\d{2})$
ARG PYTHON_BUILD_STANDALONE_RELEASE=20260610
# Provided automatically by buildx (linux/amd64 -> amd64, linux/arm64 -> arm64)
ARG TARGETARCH

# Build stage labels
LABEL org.opencontainers.image.authors="Michael Wiesendanger <michael.wiesendanger@gmail.com>" \
      org.opencontainers.image.source="https://github.com/ragedunicorn/docker-python" \
      org.opencontainers.image.licenses="MIT"

# Tool needed to download and checksum-verify the release
RUN apk add --no-cache --update curl

WORKDIR /tmp/build

# Download a pinned standalone CPython build and verify its checksum against the
# release's published SHA256SUMS before extracting it.
RUN set -eux; \
    case "$TARGETARCH" in \
      amd64) triple=x86_64-unknown-linux-musl ;; \
      arm64) triple=aarch64-unknown-linux-musl ;; \
      *) echo "unsupported architecture: $TARGETARCH" >&2; exit 1 ;; \
    esac; \
    base="https://github.com/astral-sh/python-build-standalone/releases/download/${PYTHON_BUILD_STANDALONE_RELEASE}"; \
    file="cpython-${PYTHON_VERSION}+${PYTHON_BUILD_STANDALONE_RELEASE}-${triple}-install_only_stripped.tar.gz"; \
    curl -fsSLO "${base}/${file}"; \
    curl -fsSL "${base}/SHA256SUMS" -o SHA256SUMS; \
    grep " ${file}\$" SHA256SUMS | sha256sum -c -; \
    mkdir -p /opt; \
    tar -xzf "${file}" -C /opt; \
    /opt/python/bin/python3 --version

############################################
# Runtime stage
############################################
FROM alpine:3.24.0

ARG BUILD_DATE
ARG VERSION

LABEL org.opencontainers.image.title="Python on Alpine Linux" \
      org.opencontainers.image.description="Minimal Python Docker image built on Alpine Linux with a pinned standalone CPython" \
      org.opencontainers.image.vendor="ragedunicorn" \
      org.opencontainers.image.authors="Michael Wiesendanger <michael.wiesendanger@gmail.com>" \
      org.opencontainers.image.source="https://github.com/ragedunicorn/docker-python" \
      org.opencontainers.image.documentation="https://github.com/ragedunicorn/docker-python/blob/master/README.md" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.base.name="docker.io/library/alpine:3.24.0"

# ca-certificates: TLS trust store for pip / urllib HTTPS requests
RUN apk add --no-cache ca-certificates

COPY --from=build /opt/python /opt/python

ENV PATH="/opt/python/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Ensure a `python` entrypoint exists (some standalone builds ship only python3)
RUN [ -e /opt/python/bin/python ] || ln -sf python3 /opt/python/bin/python

RUN adduser -D -s /sbin/nologin python

WORKDIR /app

RUN chown -R python:python /app

USER python

ENTRYPOINT ["python"]

CMD ["-i"]
