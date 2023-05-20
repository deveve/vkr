#!/bin/sh
set -e # Остановить скрипт при наличии ошибок
name=$1
replicas=$2
docker service scale $name=$replicas