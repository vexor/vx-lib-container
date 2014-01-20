#!/bin/bash

set -e

curl -s https://get.docker.io/gpg | sudo apt-key add -
echo deb http://get.docker.io/ubuntu docker main | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get -qqy update > /dev/null
sudo apt-get -qqy install lxc lxc-docker
sudo chmod 0666 /var/run/docker.sock

service docker start

docker build -t dmexe/precise scripts/Dockerfile
sleep 1

exit 0


