docker build --build-arg ONEC_USERNAME=${ONEC_USERNAME} \
  --build-arg ONEC_PASSWORD=${ONEC_PASSWORD} \
  --build-arg ONEC_VERSION=${ONEC_VERSION} \
  --build-arg DOCKER_REGISTRY_URL=library \
  --build-arg BASE_IMAGE=ubuntu \
  --build-arg BASE_TAG=20.04 \
  -t ${DOCKER_REGISTRY_URL}/onec-client:${ONEC_VERSION} \
  -f client/Dockerfile .

docker push $DOCKER_REGISTRY_URL/onec-client:$ONEC_VERSION

docker build --build-arg DOCKER_REGISTRY_URL=${DOCKER_REGISTRY_URL} \
  --build-arg ONEC_VERSION=$ONEC_VERSION \
  -t ${DOCKER_REGISTRY_URL}/onec-client-vnc:${ONEC_VERSION} \
  -f client-vnc/Dockerfile .

docker push $DOCKER_REGISTRY_URL/onec-client-vnc:$ONEC_VERSION

docker build --build-arg DOCKER_REGISTRY_URL=${DOCKER_REGISTRY_URL} \
  --build-arg BASE_IMAGE=onec-client-vnc \
  --build-arg BASE_TAG=$ONEC_VERSION \
  -t ${DOCKER_REGISTRY_URL}/test-runner:$ONEC_VERSION \
  -f test_runner/Dockerfile .

docker push $DOCKER_REGISTRY_URL/test-runner:$ONEC_VERSION