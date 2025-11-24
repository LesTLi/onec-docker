@echo off

call .onec.env.bat

docker build --build-arg DOCKER_REGISTRY_URL=%DOCKER_REGISTRY_URL% ^
  --build-arg ONEC_VERSION=%ONEC_VERSION% ^
  -t %DOCKER_REGISTRY_URL%/onec-client-vnc:%ONEC_VERSION% ^
  -f client-vnc/Dockerfile .
