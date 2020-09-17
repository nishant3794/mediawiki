variable "listener_arn" { }
variable "priority" { }
variable "action_type" { }
variable "forward_target_group_arn" { }
variable "redirect_host" { }
variable "redirect_path" { }
variable "redirect_port" { }
variable "redirect_protocol" { }
variable "redirect_query" { }
variable "redirect_status_code" { }
variable "fixed_response_content_type" { }
variable "fixed_response_message_body" { }
variable "fixed_response_status_code" { }
variable "condition_field" { }
variable "condition_values" { }

resource "aws_lb_listener_rule" "prod" {

  listener_arn                          = var.listener_arn
  priority                              = var.priority

  action {
    type                                = var.action_type
    target_group_arn                    = var.forward_target_group_arn

    redirect {
      host                              = var.redirect_host
      path                              = var.redirect_path
      port                              = var.redirect_port
      protocol                          = var.redirect_protocol
      query                             = var.redirect_query
      status_code                       = var.redirect_status_code
    }

    fixed_response {
      content_type                      = var.fixed_response_content_type
      message_body                      = var.fixed_response_message_body
      status_code                       = var.fixed_response_status_code
    }

    condition {
      field                             = var.condition_field
      values                            = var.condition_values
    }
  }
}
output "alb-listener-rule-id" { value = "${aws_lb_listener_rule.prod.id}" }
output "alb-listener-rule-arn" { value = "${aws_lb_listener_rule.prod.arn}" }