provider "aws" {
  region        = "ap-south-1"
}

terraform {
 backend "s3" {
   bucket       = "mediawiki-terraform-statee"
   key         = "applications/mediawiki/compute/terraform.tfstate"
   region       = "ap-south-1"
  }
}

data "aws_iam_role" "mediawiki" {
  name = "mediawiki-iam-role"
}

data "aws_security_group" "mediawiki" {
  name = "mediawiki-sg"
}

data "aws_lb_target_group" "mediawiki" {
  name = "mediawiki-tg"
}

data "aws_ami" "mediawiki" {
  most_recent = true
  owners = ["self"]
  filter {
    name      = "name"
    values    = ["baseAmi-mediawiki*"]
  }
}