#! /bin/bash


# get the name from the filename (minus extension)
Name=$(basename --suffix .sh $0)


# search the Dockerfile for images, then "pull" them
cat ./$Name-dockerfile | \
	grep --ignore-case --only-matching --perl-regex "FROM \S+" | \
	uniq --ignore-case | \
	awk '{system("docker pull " $2)}'


# build
docker build --file ./$Name-dockerfile --tag eassbhhtgu/$Name:latest .


# check for an existing stack
docker stack ls | tail --line +2 | findstr $Name


if [ $? -ne 0 ]; then
	# create one
	docker stack deploy --compose-file ./$Name-docker-compose.yml $Name
else
	# update it
	docker service ls | tail --line +2 | findstr $Name | awk '{system("docker service update --image " $5 " " $2)}'
fi
