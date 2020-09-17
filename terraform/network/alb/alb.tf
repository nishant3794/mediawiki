module "mediawiki-tg" {
  source                    = "../../modules/target_group"
  name                      = "mediawiki-tg"
  port                      = "8080"
  protocol                  = "HTTP"
  vpc_id                    = data.aws_vpc.mediawiki.id
  deregistration_delay      = "30"
  target_type               = "instance"
  health_check_enabled      = "true"
  health_check_interval     = "30"
  health_check_path         = "/"
  health_check_port         = "8080"
  health_check_protocol     = "HTTP"
  health_check_timeout      = "300"
  health_check_healthy_threshold   = "5"
  health_check_unhealthy_threshold = "2"
  tag_name                  = "mediawiki-tg"

}

module "mediawiki-alb" {
  source                    = "../../../../modules/alb"
  name                      = "mediawiki-alb"
  internal                  = "false"
  security_groups           = [data.aws_security_group.web.id]
  subnets                   = [tbd]
  idle_timeout              = "60"
  enable_deletion_protection = "true"
  ip_address_type           = "ipv4"
  tag_name                  = "mediawiki-alb"
}

module "mediawiki-alb_listener-http" {
  source                    = "../../../../modules/alb_listener"
  load_balancer_arn         = "${module.mediawiki-alb.alb-arn}"
  port                      = "80"
  protocol                  = "HTTP"
  ssl_policy                = ""
  certificate_arn           = ""
  default_action_type       = "redirect"
  forward_target_group_arn  = ""
  redirect_host             = "#{host}"
  redirect_path             = "/#{path}"
  redirect_port             = "443"
  redirect_protocol         = "HTTPS"
  redirect_query            = "#{query}"
  redirect_status_code      = "HTTP_301"
}

module "alb_listener-https" {
  source                    = "../../../../modules/alb_listener"
  load_balancer_arn         = "${module.mediawiki-alb.alb-arn}"
  port                      = "443"
  protocol                  = "HTTPS"
  ssl_policy                = "TLS-1-2-2017-01"
  certificate_arn           = data.aws_acm_certificate.cert.arn
  default_action_type       = "forward"
  forward_target_group_arn  = "${module.mediawiki-tg.tg-arn}"
  redirect_host             = ""
  redirect_path             = ""
  redirect_port             = ""
  redirect_protocol         = "HTTPS"
  redirect_query            = ""
  redirect_status_code      = "HTTP_301"
}

output "mediawiki-tg-arn"   { value = "${module.mediawiki-tg.tg-arn}" }
output "mediawiki-alb-dns-name"   { value = "${module.mediawiki-alb.alb-dns-name}" }