#!/bin/bash
sudo yum install -y wget python3-pip jq
sudo yum install java-1.8.0-openjdk-devel
cd /tmp
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

#Install Jenkins
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sudo yum install dejavu-sans-fonts
sudo yum install xorg-x11-server-Xvfb
sudo yum install jenkins -y
sudo systemctl start jenkins