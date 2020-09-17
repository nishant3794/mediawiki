variable "name" { }
variable "min_size" { }
variable "max_size" { }
variable "default_cooldown" { }
variable "launch_configuration" { }
variable "health_check_grace_period" { }
variable "health_check_type" { }
variable "desired_capacity" { }
variable "subnets" { }
variable "target_group_arns" { }
variable "termination_policies" { }
variable "suspended_processes" { }
variable "tag_name" { }
variable "tag_BaseAmi" { }

resource "aws_autoscaling_group" "asg" {
  name                            = var.name
  min_size                        = var.min_size
  max_size                        = var.max_size
  default_cooldown                = var.default_cooldown
  launch_configuration            = var.launch_configuration
  health_check_grace_period       = var.health_check_grace_period
  health_check_type               = var.health_check_type
  desired_capacity                = var.desired_capacity
  vpc_zone_identifier             = var.subnets
  target_group_arns               = var.target_group_arns
  termination_policies            = var.termination_policies
  suspended_processes             = var.suspended_processes
  tags = [
    {
      key                 = "Name"
      value               = var.tag_name
      propagate_at_launch = true
    },
    {
      key                 = "BaseAmi"
      value               = var.tag_BaseAmi
      propagate_at_launch = true
    }
  ]
  lifecycle {
    create_before_destroy = true
  }
}
output "asg-id" { value = "${aws_autoscaling_group.asg.id}" }
output "asg-arn" { value = "${aws_autoscaling_group.asg.arn}" }
output "asg-name" { value = "${aws_autoscaling_group.asg.name}" }