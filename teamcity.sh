#! /bin/bash

# cleanup
if [ -d "teamcity-docker-agent" ]; then
  rm --force --recursive ./teamcity-docker-agent/
fi

# clone the agent repo
git clone https://github.com/JetBrains/teamcity-docker-agent.git

#
pushd ./teamcity-docker-agent/

# modify ./ubuntu/Dockerfile
# fully-qualify "FROM teamcity-minimal-agent:latest" on line 1
sed --expression='s/\bFROM teamcity-minimal-agent:latest\b/FROM jetbrains\/teamcity-minimal-agent:latest/g' --in-place ./ubuntu/Dockerfile
# change the sdk version
sed --expression='s/\bDOTNET_SDK_VERSION=3\.1\.100\b/DOTNET_SDK_VERSION=5.0.100-preview.5.20279.10/g' --in-place ./ubuntu/Dockerfile

# build the image
docker build --file ./ubuntu/Dockerfile --tag eassbhhtgu/teamcity-net5-agent:latest .

#
popd

# cleanup
rm --force --recursive ./teamcity-docker-agent/
