ARG DOCKER_REGISTRY_URL=library
ARG BASE_IMAGE=debian
ARG BASE_TAG=bookworm-slim

FROM ${DOCKER_REGISTRY_URL}/${BASE_IMAGE}:${BASE_TAG}

LABEL maintainer="Nikita Gryzlov <NikGryzlov@1bit.com>, FirstBit"

# Install OpenJDK
ARG OPENJDK_VERSION=17

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates \
      git \
      locales \
      openjdk-${OPENJDK_VERSION}-jdk \
  && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8

# remove DST Root CA X3 cert if it exists
COPY ./scripts/remove-dst-root-ca-x3.sh /remove-dst-root-ca-x3.sh
RUN chmod +x /remove-dst-root-ca-x3.sh \
  && /remove-dst-root-ca-x3.sh \
  && rm /remove-dst-root-ca-x3.sh

ENV LANG ru_RU.UTF-8
