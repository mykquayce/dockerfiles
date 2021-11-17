#! /bin/bash

# pull the latest base image
docker pull pihole/pihole:latest

# build image
docker build --tag eassbhhtgu/pihole:latest --file ./pihole-dockerfile .

# push image to dockerhub
docker push eassbhhtgu/pihole:latest

# is the service already running?
docker service ls --format '{{.Image}}' | grep eassbhhtgu/pihole:latest

if [ $? -ne 0 ]; then
	# create it
	docker stack deploy --compose-file ./pihole-docker-compose.yml pihole
else
	# update it
	docker service ls --format '{{.Image}} {{.Name}}' | \
		findstr eassbhhtgu/pihole:latest | \
		awk '{system("docker service update --image " $1 " " $2)}'
fi
