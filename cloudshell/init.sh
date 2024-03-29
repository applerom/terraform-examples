#!/bin/sh

## git clone -b develop https://github.com/applerom/terraform-examples
## cd terraform-examples/cloudshell
## chmod +x init.sh
## ./init.sh
## . ~/.bashrc

## cd ../iam
## echo 'accounts=["917902836630"]' > terraform.tfvars
## tf init
## tf plan
## tf apply --auto-approve

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
echo "create ~/.terraform.d and ~/.terraformrc for caching providers"
mkdir ~/.terraform.d
echo 'plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"' > ~/.terraformrc

echo "run manually: . ~/.bashrc"
