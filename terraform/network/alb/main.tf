provider "aws" {
  region        = "ap-south-1"
}

terraform {
 backend "s3" {
   bucket       = "mediawiki-terraform-statee"
   key         = "network/alb/terraform.tfstate"
   region       = "ap-south-1"
  }
}
data "aws_vpc" "mediawiki" {
  tags = {
    Name = "default"
  }
}

data "aws_security_group" "web" {
  name = "stage-optix-web-sg"
}