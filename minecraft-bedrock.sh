#! /bin/bash


# get the name from the filename (minus extension)
Name=$(echo -n $0 | xargs basename --suffix .sh)


if [ ! -d ./$Name ];
then
	mkdir ./$Name
fi


# get the webpage
html=$(curl --url https://www.minecraft.net/en-us/download/server/bedrock/)


# scrape
uri=$(echo -n $html | \
	grep --ignore-case \
		--only-matching \
		--perl-regex "https:\/\/minecraft\.azureedge\.net\/bin-linux\/bedrock-server-\d+\.\d+\.\d+\.\d+\.zip")


# extract filename
file_name=$(echo -n $uri | grep --ignore-case --only-matching --perl-regex "bedrock-server-\d+\.\d+\.\d+\.\d+.zip")


# if it exists in the archive...
if [ -f ./$Name/$file_name ];
then
	exit 0
fi


# download to the archive directory
curl --output ./$Name/$file_name --url $uri


# copy the latest, to be picked up by the Dockerfile
cp --update $(ls -1 -t ./$Name/$file_name) ./bedrock-server.zip


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


# push
docker push eassbhhtgu/minecraft-bedrock:latest
