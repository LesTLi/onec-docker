@echo off

call .onec.env.bat

docker build --build-arg ONEC_USERNAME=%ONEC_USERNAME% ^
  --build-arg ONEC_PASSWORD=%ONEC_PASSWORD% ^
  --build-arg ONEC_VERSION=%ONEC_VERSION% ^
  --build-arg DOCKER_REGISTRY_URL=library ^
  --build-arg BASE_IMAGE=ubuntu ^
  --build-arg BASE_TAG=18.04 ^
  -t %DOCKER_REGISTRY_URL%/onec-client:%ONEC_VERSION% ^
  -f client/Dockerfile .

docker build --build-arg DOCKER_REGISTRY_URL=%DOCKER_REGISTRY_URL% ^
  --build-arg ONEC_VERSION=%ONEC_VERSION% ^
  -t %DOCKER_REGISTRY_URL%/onec-client-vnc:%ONEC_VERSION% ^
  -f client-vnc/Dockerfile .

docker build --build-arg DOCKER_REGISTRY_URL=%DOCKER_REGISTRY_URL% ^
  --build-arg BASE_IMAGE=onec-client-vnc ^
  --build-arg BASE_TAG=%ONEC_VERSION% ^
  -t %DOCKER_REGISTRY_URL%/oscript:stable ^
  -f oscript/Dockerfile .

docker build --build-arg DOCKER_REGISTRY_URL=%DOCKER_REGISTRY_URL% ^
  --build-arg BASE_TAG=stable ^
  -t %DOCKER_REGISTRY_URL%/oscript-utils:latest ^
  -f oscript-utils/Dockerfile .

SET OPENJDK_VERSION=21

docker build --build-arg DOCKER_REGISTRY_URL=%DOCKER_REGISTRY_URL% ^
  --build-arg BASE_IMAGE=oscript-utils ^
  --build-arg BASE_TAG=latest ^
  --build-arg OPENJDK_VERSION=%OPENJDK_VERSION% ^
  -t %DOCKER_REGISTRY_URL%/jdk:%OPENJDK_VERSION% ^
  -f jdk/Dockerfile .

docker build --build-arg DOCKER_REGISTRY_URL=%DOCKER_REGISTRY_URL% ^
  --build-arg BASE_IMAGE=jdk ^
  --build-arg BASE_TAG=%OPENJDK_VERSION% ^
  -t %DOCKER_REGISTRY_URL%/test-runner:%ONEC_VERSION% ^
  -f test_runner/Dockerfile .

docker build --build-arg DOCKER_REGISTRY_URL=%DOCKER_REGISTRY_URL% ^
  --build-arg BASE_IMAGE=test-runner ^
  --build-arg BASE_TAG=%ONEC_VERSION% ^
  -t %DOCKER_REGISTRY_URL%/jenkins-agent:%ONEC_VERSION% ^
  -f swarm-jenkins-agent/Dockerfile .

docker save ^
  localhost:5000/onec-client:8.3.25.1445 ^
  localhost:5000/onec-client-vnc:8.3.25.1445 ^
  localhost:5000/oscript:stable ^
  localhost:5000/oscript-utils:latest ^
  localhost:5000/jdk:21 ^
  localhost:5000/test-runner:8.3.25.1445 ^
  localhost:5000/jenkins-agent:8.3.25.1445 ^
  -o F:\all.tar

@REM docker push %DOCKER_REGISTRY_URL%/onec-client:%ONEC_VERSION%
@REM docker push %DOCKER_REGISTRY_URL%/onec-client-vnc:%ONEC_VERSION%
@REM docker push %DOCKER_REGISTRY_URL%/oscript:stable
@REM docker push %DOCKER_REGISTRY_URL%/oscript-utils:latest
@REM docker push %DOCKER_REGISTRY_URL%/test-runner:%ONEC_VERSION%