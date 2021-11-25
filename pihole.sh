#! /bin/bash

# pull the latest base image
docker pull pihole/pihole:latest | \
	grep --ignore-case 'Status: Downloaded newer image for'

# if already up to date
if [ $? -ne 0 ]; then echo everything up to date; exit 0; fi

# build image
docker build --tag eassbhhtgu/pihole:latest --file ./pihole-dockerfile .
if [ $? -ne 0 ]; then exit 1; fi

# push image to dockerhub
docker push eassbhhtgu/pihole:latest
