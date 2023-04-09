#!/bin/sh
set -e # Остановить скрипт при наличии ошибок

read -p "Вставьте ссылку на Git repo: " gitlink
read -p "Введите номер порта: " port 
read -p "Введите номер порта внутри контейнера: " port_cont
read -p "Введите имя контейнера: " name
read -p "Введите папку с проектом внутри Git: " path
read -p "Введите кол-во реплик от 1 до 3: " replicas

#Качаем репозиторий
git clone $gitlink $name

cp dockerfile $name/$path

cd $name/$path

docker build . -t $name 
docker tag $name localhost:5000/$name
docker push localhost:5000/$name
docker service create --name $name --with-registry-auth --replicas $replicas localhost:5000/$name
#docker volume create $name
#docker run --rm -p $port:$port_cont -d --name $name $name

#config nginx

