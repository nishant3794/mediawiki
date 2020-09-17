provider "aws" {
  region        = "ap-south-1"
}

terraform {
 backend "s3" {
   bucket       = "mediawiki-terraform-statee"
   key         = "applications/jenkins/terraform.tfstate"
   region       = "ap-south-1"
  }
}

data "aws_vpc" "default" {
  tags = {
    Name = "default"
  }
}

data "aws_subnet" "public" {
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "public-subnet-2"
  }
}

data "aws_iam_instance_profile" "jenkins" {
  name = "admin-role-for-jenkins"
}

data "aws_security_group" "jenkins" {
  name = "jenkins-sg"
}

data "aws_ami" "jenkins" {
owners      = ["679593333241"]
most_recent = true

  filter {
      name   = "name"
      values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
      name   = "architecture"
      values = ["x86_64"]
  }

  filter {
      name   = "root-device-type"
      values = ["ebs"]
  }
}