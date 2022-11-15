#!/bin/sh

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

mkdir ~/bin
cp /usr/bin/terraform ~/bin
cp cloudshell.bashrc ~/.bashrc
. ~/.bashrc
