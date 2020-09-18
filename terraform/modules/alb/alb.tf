variable "name" { }
variable "internal" { }
variable "load_balancer_type" { default = "application" }
variable "security_groups" {  }
variable "subnets" { }
variable "idle_timeout" { default = "60" }
variable "enable_deletion_protection" { default = "false" }
variable "ip_address_type" { }
variable "tag_name" { }

resource "aws_lb" "lb" {

  name                          = var.name
  internal                      = var.internal
  security_groups               = var.security_groups
  subnets                       = var.subnets
  idle_timeout                  = var.idle_timeout
  enable_deletion_protection    = var.enable_deletion_protection
  ip_address_type               = var.ip_address_type
  tags = {
    Name                        = var.tag_name
  }
}

output "alb-id" { value = "${aws_lb.lb.id}" }
output "alb-arn" { value = "${aws_lb.lb.arn}" }
output "alb-dns-name" { value = "${aws_lb.lb.dns_name}" }