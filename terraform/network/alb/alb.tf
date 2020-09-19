module "mediawiki-tg" {
  source                    = "../../modules/target_group"
  name                      = "mediawiki-tg"
  port                      = "80"
  protocol                  = "HTTP"
  vpc_id                    = data.aws_vpc.default.id
  deregistration_delay      = "30"
  target_type               = "instance"
  health_check_enabled      = "true"
  health_check_interval     = "30"
  health_check_path         = "/index.php/Main_Page"
  health_check_port         = "80"
  health_check_protocol     = "HTTP"
  health_check_timeout      = "300"
  health_check_healthy_threshold   = "5"
  health_check_unhealthy_threshold = "2"

}

module "mediawiki-alb" {
  source                    = "../../modules/alb"
  name                      = "mediawiki-alb"
  internal                  = "false"
  security_groups           = [data.aws_security_group.web.id]
  subnets                   = ["subnet-0bc21093b6e6b937c", "subnet-ebb53490", "subnet-082ad0888493cb11b"]
  idle_timeout              = "60"
  enable_deletion_protection = "true"
  ip_address_type           = "ipv4"
  tag_name                  = "mediawiki-alb"
}

module "mediawiki-alb_listener-http" {
  source                    = "../../modules/alb_listener"
  load_balancer_arn         = "${module.mediawiki-alb.alb-arn}"
  port                      = "80"
  protocol                  = "HTTP"
  ssl_policy                = ""
  certificate_arn           = ""
  default_action_type       = "forward"
  forward_target_group_arn  = "${module.mediawiki-tg.tg-arn}"
  redirect_host             = "#{host}"
  redirect_path             = "/#{path}"
  redirect_port             = "443"
  redirect_protocol         = "HTTPS"
  redirect_query            = "#{query}"
  redirect_status_code      = "HTTP_301"
}

output "mediawiki-tg-arn"   { value = "${module.mediawiki-tg.tg-arn}" }
output "mediawiki-alb-dns-name"   { value = "${module.mediawiki-alb.alb-dns-name}" }
