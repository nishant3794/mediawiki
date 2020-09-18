variable "name" { }
variable "port" { }
variable "protocol" { }
variable "vpc_id" { }
variable "deregistration_delay" { }
variable "health_check_enabled" { }
variable "health_check_interval" { }
variable "health_check_path" { }
variable "health_check_port" { }
variable "health_check_protocol" { }
variable "health_check_timeout" { }
variable "health_check_healthy_threshold" { }
variable "health_check_unhealthy_threshold" { }
variable "target_type" { default = "instance" }
variable "matcher" { default = "200" }

resource "aws_lb_target_group" "tg" {

  name                      = var.name
  port                      = var.port
  protocol                  = var.protocol
  vpc_id                    = var.vpc_id
  deregistration_delay      = var.deregistration_delay
  target_type               = var.target_type

  health_check {
    enabled                 = var.health_check_enabled
    interval                = var.health_check_interval
    path                    = var.health_check_path
    port                    = var.health_check_port
    protocol                = var.health_check_protocol
    healthy_threshold       = var.health_check_healthy_threshold
    unhealthy_threshold     = var.health_check_unhealthy_threshold
    matcher                 = var.matcher
  }
}

output "tg-id" { value = "${aws_lb_target_group.tg.id}" }
output "tg-arn" { value = "${aws_lb_target_group.tg.arn}" }
output "tg-name" { value = "${aws_lb_target_group.tg.name}" }