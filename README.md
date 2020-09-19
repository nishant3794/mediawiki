# Automating mediawiki deployment 

This is a code for installing and deploying mediawiki usin **Terraform**, **Packer**, **Ansible** and **Bash**.

### Step 1
Run `packer build mediawiki.json` in the packer folder from an instance having permissions to create instance, create AMI.
Alternatively setup jenkins to automate building the AMI. Reference:go to http://jenkins.thenishant.com and build `packer-build-images`.
This will create a new AMI with the prerequisites for mediawiki installation and install mediawiki.

### Step 2
Run `terraform` in the `terraform/applications/mediawiki/compute` folder to get the mediawiki up and running.
Alternatively setup jenkins to automate provisioning infra for mediawiki. Reference:go to http://jenkins.thenishant.com and build `terraform-provision-infra`.
This will deploy mediawiki and will be accessible at https://mediawiki.thenishant.com

### Step 3
Setup code deployment using jenkins. Reference: http://jenkins.thenishant.com. Pass ASG name, target group arn and final desired capacity of ASG as parameters. 
The code will launch new instances and the userdata will fetch the latest tar from s3 and deploy on new instances.

## Notes:
* Using external DB(AWS RDS) instead of localhost for wiki to make scaling work.
* The RDS credentials are being fetched from AWS Secrets Manager.
* ASG Scale up will happen if/when CPU>30.
* ASG Scale down will happen if/when CPU<29.
* Ask me for credentials on Jenkins(for references)