ARG DOCKER_REGISTRY_URL
ARG BASE_IMAGE
ARG BASE_TAG
ARG ONEC_VERSION


FROM ${DOCKER_REGISTRY_URL:+"$DOCKER_REGISTRY_URL/"}${BASE_IMAGE}:${BASE_TAG}

# Installing additional dependencies
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    cifs-utils \
    inetutils-ping \
    net-tools \
    pandoc \
    scrot \
  && rm -rf /var/lib/apt/lists/*

RUN echo '#!/bin/bash\n\nscrot "${@:2}"' | tee /usr/local/bin/nircmd \
  && chmod +x /usr/local/bin/nircmd \
  && rm -rf /etc/services.d/onec 2> /dev/null
ARG ONEC_VERSION
ENV PATH="/opt/1cv8/x86_64/${ONEC_VERSION}:${PATH}"
RUN ln -s /opt/1cv8/x86_64/${ONEC_VERSION}/ibcmd /usr/local/bin/ibcmd && \
    ln -s /opt/1cv8/x86_64/${ONEC_VERSION}/ibsrv /usr/local/bin/ibsrv && \
    ln -s /opt/1cv8/x86_64/${ONEC_VERSION}/1cv8 /usr/local/bin/1cv8
