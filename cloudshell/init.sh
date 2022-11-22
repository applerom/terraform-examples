#!/bin/sh

## install Terraform to Amazon Linux 2
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

echo "create ~/bin"
mkdir ~/bin
echo "copy terraform to ~/bin because only the files in home folder remain after the session ends"
cp /usr/bin/terraform ~/bin
echo "customize ~/.bashrc - making the cloudshell interface beautiful"
cp .bashrc ~/.bashrc
. ~/.bashrc
