#!/bin/bash

# Username of Linux
echo "Enter Your Username :"
read USERNAME
echo "Username : " $USERNAME

# Update & Upgrade
echo "system update & plugin installation"

sudo apt update
sudo apt install unzip wget curl -y

echo "system update & plugin installation completed!!!"

# Install Docker
echo "docker installing"

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh

echo "docker installation completed!!!"

# Service start & enable
echo "docker service going to start"

sudo systemctl start docker
sudo systemctl enable docker

echo "docker service enable and stated!!!"

# User add in Docker group
echo "user adding in docker group"

sudo usermod -aG docker $USERNAME

echo "user added in docker group"

# Install awsclient
echo "awsclient installing"

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

echo "awsclient installation completed!!!"

# Install EKS kubectl
echo "EKS kubectl installing"

curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.35.3/2026-04-08/bin/linux/amd64/kubectl
sha256sum -c kubectl.sha256
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH

echo "EKS kubectl installation completed!!!"

# EKS version 
echo "checking the kubectl installed or not"
kubectl version

# for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

# (Optional) Verify checksum
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check

tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz

sudo install -m 0755 /tmp/eksctl /usr/local/bin && rm /tmp/eksctl

echo "Script completed !!!!"
