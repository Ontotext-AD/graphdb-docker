#!/bin/bash

#not sure why, but the install commands fail sometimes, I suspect the network is not ready or something
sleep 10
#create the test data dir and mount the attached hdd
sudo mkdir /opt/temp-test-data
sudo amazon-linux-extras enable docker;
sudo service docker start;
sudo docker ps;
sudo usermod -aG docker `echo $USER`;
sudo chmod -R 0777 /opt/temp-test-data
cd /opt/temp-test-data
git clone https://github.com/Ontotext-AD/graphdb-docker.git
cd graphdb-docker
make -e VERSION=${GRAPHDB_VERSION} build-image-arm64
docker login -u "${DOCKERHUB_USERNAME}" -p "${DOCKERHUB_PASSWORD}" docker.io
docker push ontotext/graphdb:${GRAPHDB_VERSION}-arm64
