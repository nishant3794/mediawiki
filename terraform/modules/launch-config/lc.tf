variable "name" { }
variable "image_id" { }
variable "instance_type" { }
variable "iam_instance_profile" { }
variable "key_name" { }
variable "security_groups" { }
variable "associate_public_ip_address" { }
variable "user_data" { }
variable "placement_tenancy" { }
variable "root_volume_type" { }
variable "root_volume_size" { }
variable "root_delete_on_termination" { }
variable "root_encrypted" { default = "true" }

resource "aws_launch_configuration" "lc" {
    name                              = var.name
    image_id                          = var.image_id
    instance_type                     = var.instance_type
    iam_instance_profile              = var.iam_instance_profile
    key_name                          = var.key_name
    security_groups                   = var.security_groups
    associate_public_ip_address       = var.associate_public_ip_address
    user_data                         = var.user_data
    placement_tenancy                 = var.placement_tenancy
    root_block_device {
      volume_type                     = var.root_volume_type
      volume_size                     = var.root_volume_size
      delete_on_termination           = var.root_delete_on_termination
      encrypted                       = var.root_encrypted
    }
    lifecycle {
      create_before_destroy           = true
    }
}

output "lc-id" { value = "${aws_launch_configuration.lc.id}" }
output "lc-name" { value = "${aws_launch_configuration.lc.name}" }