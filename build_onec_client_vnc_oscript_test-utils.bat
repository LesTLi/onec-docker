@echo off

call .onec.env.bat

docker build --build-arg DOCKER_REGISTRY_URL=%DOCKER_REGISTRY_URL% ^
  --build-arg BASE_IMAGE=onec-client-vnc-oscript ^
  --build-arg BASE_TAG=%ONEC_VERSION% ^
  -t %DOCKER_REGISTRY_URL%/onec-client-vnc-oscript-test_utils:%ONEC_VERSION% ^
  -f test-utils/Dockerfile .
