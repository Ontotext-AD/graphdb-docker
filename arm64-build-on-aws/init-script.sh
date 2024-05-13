#!/bin/bash

#not sure why, but the install commands fail sometimes, I suspect the network is not ready or something
sleep 10
#create the test data dir and mount the attached hdd
sudo mkdir /opt/temp-test-data
sudo yum update -y;
sudo amazon-linux-extras enable docker;
sudo yum install -y docker git;
sudo service docker start;
sudo docker ps;
sudo usermod -aG docker `echo $USER`;
sudo chmod -R 0777 /opt/temp-test-data
cd /opt/temp-test-data
git clone https://github.com/Ontotext-AD/graphdb-docker.git
cd graphdb-docker
sudo make -e VERSION=${GRAPHDB_VERSION} -e ARCH=arm64 build
sudo docker login -u "${DOCKERHUB_USERNAME}" -p "${DOCKERHUB_PASSWORD}" docker.io
sudo docker push ontotext/graphdb:${GRAPHDB_VERSION}-arm64
