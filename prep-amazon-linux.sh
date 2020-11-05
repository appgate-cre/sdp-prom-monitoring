#!/bin/bash

sudo amazon-linux-extras install -y docker
sudo systemctl enable docker
sudo systemctl start docker
sudo docker swarm init

sudo usermod -a -G docker ec2-user #sudo gpasswd -a ec2-user docker
sudo setfacl -m user:ec2-user:rw /var/run/docker.sock

sudo yum -y install httpd-tools

