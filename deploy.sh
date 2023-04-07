#!/bin/sh
set -e # Остановить скрипт при наличии ошибок

#Берем ссылку на репозиторий
read -p "Вставьте ссылку на Git repo" gitlink 

#Качаем репозиторий
git clone $gitlink 

docker build . -t newnodejs

docker run -p 8080:8080 -d newnodejs

