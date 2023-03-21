#!/bin/sh
set -e # Остановить скрипт при наличии ошибок

IMAGE="<username>/<repository>"                             # Образ Docker
GIT_VERSION=$(git describe --always --abbrev --tags --long) # Git-хэш и теги

# Сборка и тегирование образа
docker build -t ${IMAGE}:${GIT_VERSION} .
docker tag ${IMAGE}:${GIT_VERSION} ${IMAGE}:latest

# Вход в Docker Hub и выгрузка образа
echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
docker push ${IMAGE}:${GIT_VERSION}