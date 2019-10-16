#! /bin/bash

if [ -d "teamcity-docker-agent" ]; then
  rm --force --recursive --force ./teamcity-docker-agent/
fi

git clone https://github.com/JetBrains/teamcity-docker-agent.git

pushd ./teamcity-docker-agent/

sed -i -e 's/teamcity-minimal-agent:latest/jetbrains\/teamcity-minimal-agent:latest/g' ./ubuntu/Dockerfile
sed -i -e 's/DOTNET_SDK_VERSION=2\.2\.103/DOTNET_SDK_VERSION=3.0.100/g' ./ubuntu/Dockerfile

docker build --file ./ubuntu/Dockerfile --tag jetbrains/teamcity-netcore3-agent .

popd

rm --force --recursive --force ./teamcity-docker-agent/
