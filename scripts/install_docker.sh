#!/bin/sh

sudo apt-get update > /dev/null
sudo apt-get install -y --force-yes git build-essential

# Add docker key server
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# Install Docker!
sudo apt-get update &&
sudo apt-get install -y apt-transport-https ca-certificates &&
sudo apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual &&
    curl -fsSL https://yum.dockerproject.org/gpg | sudo apt-key add - &&
    apt-key fingerprint 58118E89F3A912897C070ADBF76221572C52609D

sudo add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       ubuntu-$(lsb_release -cs) \
       main"

sudo apt-get update && sudo apt-get -y install docker-engine && sudo service docker start

#sudo docker run hello-world
sudo gpasswd -a ${USER} docker
sudo usermod -aG docker $USER
# restart server
