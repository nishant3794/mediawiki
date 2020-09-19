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

data "aws_vpc" "default" {
  tags = {
    Name = "default"
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.default.id
  tags = {
    Privacy = "private"
  }
}

data "aws_iam_role" "mediawiki" {
  name = "mediawiki-role"
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
    values    = ["mediawiki-base-image*"]
  }
}