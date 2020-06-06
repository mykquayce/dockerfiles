#! /bin/bash

if [ -d "teamcity-docker-agent" ]; then
  rm --force --recursive ./teamcity-docker-agent/
fi

git clone https://github.com/JetBrains/teamcity-docker-agent.git

pushd ./teamcity-docker-agent/

sed --expression='s/\bFROM teamcity-minimal-agent:latest\b/FROM jetbrains\/teamcity-minimal-agent:latest/g' --in-place ./ubuntu/Dockerfile
sed --expression='s/\bDOTNET_SDK_VERSION=2\.2\.103/DOTNET_SDK_VERSION=3.0.100/g' --in-place ./ubuntu/Dockerfile

docker build --file ./ubuntu/Dockerfile --tag eassbhhtgu/teamcity-net5-agent:latest .

popd

rm --force --recursive ./teamcity-docker-agent/
