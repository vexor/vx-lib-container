#!/bin/sh

set -e
set -x

cd /root

apt-get update -y
apt-get install software-properties-common -y
add-apt-repository ppa:brightbox/ruby-ng-experimental -y
apt-get update -y
apt-get install ruby2.1 -y
gem install bundler --no-ri --no-rdoc

curl -sSL https://get.docker.com/ | sh

curl -o insecure_key -fSL https://github.com/phusion/baseimage-docker/raw/master/image/insecure_key
chmod 600 insecure_key

docker pull phusion/baseimage:0.9.15
