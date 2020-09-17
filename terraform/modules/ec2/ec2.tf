variable "ami" { }
variable "instance_type" { }
variable "key_name" { }
variable "security_groups" { }
variable "subnet_id" { }
variable "associate_public_ip_address" { }
variable "user_data" { }
variable "iam_instance_profile" { }
variable "service" { }
variable "root_volume_type" { }
variable "root_volume_size" { }
variable "root_delete_on_termination" { }

resource "aws_instance" "ec2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = var.security_groups
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  user_data                   = var.user_data
  iam_instance_profile        = var.iam_instance_profile

  root_block_device {
    volume_type               = var.root_volume_type
    volume_size               = var.root_volume_size
    delete_on_termination     = var.root_delete_on_termination
  }

  tags = {
    Name                      = "${var.service}-app"
    Service                   = var.service
  }

}