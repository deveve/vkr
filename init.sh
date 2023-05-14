#!/bin/sh
set -e # Остановить скрипт при наличии ошибок

curl -sSL https://get.docker.com | sh
docker swarm init >> swarm_key
docker volume create portainer_data
docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
docker run -d -p 5000:5000 --restart=always --name registry registry:2
systemctl restart docker