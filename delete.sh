#!/bin/sh
set -e # Остановить скрипт при наличии ошибок

read -p "Введите имя контейнера: " name

docker stop $name
docker rm $name