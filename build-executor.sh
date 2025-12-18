#!/usr/bin/env bash
set -eo pipefail

if [ -n "${DOCKER_LOGIN}" ] && [ -n "${DOCKER_PASSWORD}" ] && [ -n "${DOCKER_REGISTRY_URL}" ]; then
    if ! docker login -u "${DOCKER_LOGIN}" -p "${DOCKER_PASSWORD}" "${DOCKER_REGISTRY_URL}"; then
        echo "Docker login failed"
        exit 1
    fi
else
    echo "Skipping Docker login due to missing credentials"
fi

if [ "${DOCKER_SYSTEM_PRUNE}" = 'true' ] ; then
    docker system prune -af
fi

last_arg='.'
if [ "${NO_CACHE}" = 'true' ] ; then
    last_arg='--no-cache .'
fi

# Проверяем, что переменная окружения установлена
if [ -z "$DEV1C_EXECUTOR_API_KEY" ]; then
    echo "Переменная среды DEV1C_EXECUTOR_API_KEY не установлена."
    exit 1
fi

# Записываем значение переменной в файл
umask 077
echo -n "$DEV1C_EXECUTOR_API_KEY" > /tmp/dev1c_executor_api_key.txt
echo "Ключ успешно записан в /tmp/dev1c_executor_api_key.txt"

executor_version=$EXECUTOR_VERSION

DOCKER_BUILDKIT=1 docker build \
    --secret id=dev1c_executor_api_key,src=/tmp/dev1c_executor_api_key.txt \
    --pull \
    --build-arg EXECUTOR_VERSION="$EXECUTOR_VERSION" \
    -t ${DOCKER_REGISTRY_URL:+"$DOCKER_REGISTRY_URL/"}executor:$executor_version \
    -f "executor/Dockerfile" \
    $last_arg

shred -fzu "/tmp/dev1c_executor_api_key.txt" || true

if [[ -n "$DOCKER_REGISTRY_URL" ]]; then
  docker push $DOCKER_REGISTRY_URL/executor:$executor_version
else
  echo "DOCKER_REGISTRY_URL not set, skipping docker push."
fi
