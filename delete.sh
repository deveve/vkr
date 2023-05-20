#!/bin/sh
set -e # Остановить скрипт при наличии ошибок

docker service rm $1
rm -rf /vkr/$1
rm -rf /etc/nginx/sites-enabled/$1.orch.ishkov.su.config
rm -rf /etc/nginx/conf.d/backend_$1.conf