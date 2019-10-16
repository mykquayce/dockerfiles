mkdir ~/sabnzbd
mkdir ~/sabnzbd/Downloads
mkdir ~/sabnzbd/Downloads/complete
mkdir ~/sickgear

docker stack deploy --compose-file ./mediaserver-docker-compose.yml mediaserver
