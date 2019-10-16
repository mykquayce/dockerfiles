#! /bin/bash

for s in mysql-root-password rabbitmq-password rabbitmq-username
do
  docker secret ls | tail --line +2 | grep $s >nul

  if [ $? -ne 0 ]; then
    openssl rand -base64 201 | sed 's/[^0-9A-Za-z]//g' | sed -z 's/\n//g' | docker secret create $s -
  fi
done
