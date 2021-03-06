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
data "aws_vpc" "default" {
  tags = {
    Name = "default"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.default.id
  tags = {
    Privacy = "public"
  }
}

data "aws_security_group" "web" {
  name = "web-sg"
}