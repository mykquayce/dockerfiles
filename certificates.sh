docker pull alpine:latest

docker build --file ./certificates-dockerfile --tag eassbhhtgu/certificates:latest .

docker push eassbhhtgu/certificates:latest

# does the stack already exist?
docker stack ls --format '{{.Name}}' | findstr elgatoapi

if [ $? -ne 0 ]; then
	# deploy
	docker stack deploy --compose-file ./certificates-docker-compose.yml certificates
else
	# update
	docker service ls --format '{{.Image}} {{.Name}}' | \
		findstr certificates | \
		awk '{system("docker service update --image " $1 " " $2)}'
fi
