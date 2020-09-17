#!/bin/bash
yum update -y
sudo yum install epel-release -y
sudo yum install ansible wget curl python3 -y
sudo pip3 install PyMySQL
