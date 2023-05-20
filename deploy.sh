#!/bin/sh
set -e # Остановить скрипт при наличии ошибок

gitlink=$1 #ссылка на Git repo
port=$2 #номер порта port
port_cont=$3 #номер порта внутри контейнера
replicas=$4 #кол-во реплик
path=$5 #папка с проектом внутри Git


#Качаем репозиторий
git clone $gitlink $port
#Копируем докерфайл в директорию с проектом
cp dockerfile $port/$path
cp .dockerignore $port/$path
#Переходим в директорию проекта
cd $port/$path
#Собираем контейнер
docker build . -t $port 
#Создаем образ
docker tag $port localhost:5000/$port
#Заливаем образ в Docker Registry
docker push localhost:5000/$port
#Деплоим сервис в Swarm
docker service create --name $port -p $port:$port_cont --with-registry-auth --replicas $replicas 192.168.0.102:5000/$port

#Делаем доступ к сервису по домену
cp /vkr/nginxex /etc/nginx/sites-enabled/$port.orch.ishkov.su.config
cp /vkr/upstream /etc/nginx/conf.d/backend_$port.conf
sed -i 's/%port%/'$port'/' /etc/nginx/sites-enabled/$port.orch.ishkov.su.config
sed -i 's/%port%/'$port'/' /etc/nginx/conf.d/backend_$port.conf
nginx -s reload

echo "Сервис доступен по адерсу '$port'.orch.ishkov.su"
