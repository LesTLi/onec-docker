#!/usr/bin/env bash
set -eo pipefail

# Docker login
if [ -n "${DOCKER_LOGIN}" ] && [ -n "${DOCKER_PASSWORD}" ] && [ -n "${DOCKER_REGISTRY_URL}" ]; then
    docker login -u "${DOCKER_LOGIN}" -p "${DOCKER_PASSWORD}" "${DOCKER_REGISTRY_URL}" || {
        echo "Docker login failed"
        exit 1
    }
else
    echo "Skipping Docker login due to missing credentials"
fi

# Очистка Docker
if [ "${DOCKER_SYSTEM_PRUNE}" = 'true' ] ; then
    docker system prune -af
fi

# Опция --no-cache
no_cache_arg=""
if [ "${NO_CACHE}" = 'true' ] ; then
    no_cache_arg="--no-cache"
fi

# Сборка Docker-образа ONEC
docker build \
  $no_cache_arg \
  --build-arg ONEC_USERNAME="$ONEC_USERNAME" \
  --build-arg ONEC_PASSWORD="$ONEC_PASSWORD" \
  --build-arg ONEC_VERSION="$ONEC_VERSION" \
  --build-arg DOCKER_REGISTRY_URL="$DOCKER_REGISTRY_URL" \
  --build-arg BASE_IMAGE="ubuntu" \
  --build-arg BASE_TAG="18.04" \
  -t "$DOCKER_REGISTRY_URL/onec-client:$ONEC_VERSION" \
  -f client/Dockerfile .

# Пушим образ
docker push "$DOCKER_REGISTRY_URL/onec-client:$ONEC_VERSION"
