provider "aws" {
  region        = "ap-south-1"
}

terraform {
 backend "s3" {
   bucket       = "mediawiki-terraform-statee"
   key         = "applications/jenkins/network/terraform.tfstate"
   region       = "ap-south-1"
  }
}

data "aws_vpc" "default" {
  tags = {
    Name = "default"
  }
}