#!/bin/bash

set -e

echo -en 'travis_fold:start:prepare\\r'
curl -s https://get.docker.io/gpg | sudo apt-key add -
echo deb http://get.docker.io/ubuntu docker main | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get -qqy update > /dev/null
echo exit 101 | sudo tee /usr/sbin/policy-rc.d
sudo chmod +x /usr/sbin/policy-rc.d
sudo apt-get -qqy install slirp lxc lxc-docker
git clone git://github.com/dima-exe/sekexe
#(cd sekexe && git checkout -qf c5119f039140194f70a7ffa83e039b88960818c7)
echo -en 'travis_fold:end:prepare\\r'

sudo sekexe/run "$(pwd)/scripts/docker.sh"

exit 0


