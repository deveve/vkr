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
#Копируем докерфайл в директорию с проектом
cp dockerfile $name/$path
#Переходим в директорию проекта
cd $name/$path

docker build . -t $name 
docker tag $name localhost:5000/$name
docker push localhost:5000/$name
docker service create --name $name -p $port:$port_cont --with-registry-auth --replicas $replicas 192.168.0.102:5000/$name
#docker volume create $name
#docker run --rm -p $port:$port_cont -d --name $name $name

#config nginx
cp ~/vkr/nginxex /etc/nginx/sites-enabled/$port.orch.ishkov.su.config
sed -i 's/_port_/'$port'/' /etc/nginx/sites-enabled/$port.orch.ishkov.su.config
nginx -s reload


