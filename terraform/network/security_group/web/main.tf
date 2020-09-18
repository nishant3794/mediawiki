provider "aws" {
  region        = "ap-south-1"
}

terraform {
 backend "s3" {
   bucket       = "mediawiki-terraform-statee"
   key         = "network/security_group/web/terraform.tfstate"
   region       = "ap-south-1"
  }
}

data "aws_vpc" "default" {
  tags = {
    Name = "default"
  }
}