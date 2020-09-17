variable "load_balancer_arn" { }
variable "port" { }
variable "protocol" { }
variable "ssl_policy" { }
variable "certificate_arn" { }
variable "default_action_type" { }
variable "forward_target_group_arn" { }
variable "redirect_host" { }
variable "redirect_path" { }
variable "redirect_port" { }
variable "redirect_protocol" { }
variable "redirect_query" { }
variable "redirect_status_code" { }

resource "aws_lb_listener" "prod" {

  load_balancer_arn                     = var.load_balancer_arn
  port                                  = var.port
  protocol                              = var.protocol
  ssl_policy                            = var.ssl_policy
  certificate_arn                       = var.certificate_arn
  default_action {
    type                                = var.default_action_type
    target_group_arn                    = var.forward_target_group_arn

    redirect {
      host                              = var.redirect_host
      path                              = var.redirect_path
      port                              = var.redirect_port
      protocol                          = var.redirect_protocol
      query                             = var.redirect_query
      status_code                       = var.redirect_status_code
    }

  }
}

output "alb-listener-id" { value = "${aws_lb_listener.prod.id}" }
output "alb-listener-arn" { value = "${aws_lb_listener.prod.arn}" }
