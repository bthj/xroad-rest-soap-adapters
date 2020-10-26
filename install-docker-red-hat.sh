#!/bin/bash

# Install Docker

sudo yum install -y yum-utils

sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

# workaround:  https://github.com/docker/for-linux/issues/1111#issuecomment-699059831
# - via https://forums.docker.com/t/docker-ce-stable-x86-64-repo-not-available-https-error-404-not-found-https-download-docker-com-linux-centos-7server-x86-64-stable-repodata-repomd-xml/98965/8
sudo yum-config-manager --setopt="docker-ce-stable.baseurl=https://download.docker.com/linux/centos/7/x86_64/stable" --save

sudo yum -y install docker-ce docker-ce-cli containerd.io

sudo systemctl start docker


# Install Docker Compose

sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose


# Verify the installation

sudo docker info

docker-compose --version
