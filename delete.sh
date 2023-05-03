#!/bin/sh
set -e # Остановить скрипт при наличии ошибок

read -p "Введите имя контейнера, который нужно удалить: " name

docker service rm $name