#!/bin/bash

export ANSIBLE_FORCE_COLOR=true
export ANSIBLE_HOST_KEY_CHECKING=False
TG_NAME="$2"
TG_ARN="$3"
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
echo $TG_NAME;
echo $TG_ARN
for i in `aws elbv2 describe-target-health --target-group-arn $TG_ARN --query 'TargetHealthDescriptions[*].Target.Id' --region ap-south-1 --output text` ;
do
        aws ec2 describe-instances --instance-ids $i |jq -r '.Reservations[].Instances[].PrivateIpAddress' >> inventory/hosts
        echo "inventory created"
done

Ansible=`which ansible-playbook`
$Ansible -e 'host_key_checking=False' deploy.yml --private-key=~/.ssh/deploy.pem -u ubuntu -i inventory --extra-vars "ansible_python_interpreter=/usr/bin/python3 asg=$1 TG_NAME=$2"

if [ $? -ne 0 ]
then
	echo "${red}Build failed , Check build logs" ${reset}
        exit 1
else
	echo "${green}Finished Build at " `date` ${reset}
fi
