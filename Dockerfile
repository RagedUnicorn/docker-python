FROM alpine:3.23.0

ARG BUILD_DATE
ARG VERSION

LABEL org.opencontainers.image.title="Python on Alpine Linux" \
      org.opencontainers.image.description="Minimal Python Docker image built on Alpine Linux" \
      org.opencontainers.image.vendor="ragedunicorn" \
      org.opencontainers.image.authors="Michael Wiesendanger <michael.wiesendanger@gmail.com>" \
      org.opencontainers.image.source="https://github.com/ragedunicorn/docker-python" \
      org.opencontainers.image.documentation="https://github.com/ragedunicorn/docker-python/blob/master/README.md" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.base.name="docker.io/library/alpine:3.22.1"

# Install Python from Alpine packages and remove PEP 668 restriction
RUN apk add --no-cache python3 py3-pip && \
    rm -f /usr/lib/python*/EXTERNALLY-MANAGED

RUN ln -sf python3 /usr/bin/python

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

RUN adduser -D -s /sbin/nologin python

WORKDIR /app

RUN chown -R python:python /app

USER python

ENTRYPOINT ["python"]

CMD ["-i"]
