module "web-sg" {
  source                    = "../../../modules/security-group"
  tag_name                  = "web-sg"
  vpc_id                    = data.aws_vpc.default.id
  description               = "Security group for jenkins App"
  ingress_from_ports        = ["443", "80"]
  ingress_to_ports          = ["443", "80"]
  ingress_protocols         = ["tcp", "tcp"]
  ingress_cidr_blocks       = ["0.0.0.0/0", "0.0.0.0/0"]
  ingress_cidr_descriptions = ["https", "http"]
  ingress_sgid_from_ports   = []
  ingress_sgid_to_ports     = []
  ingress_sgid_protocols    = []
  ingress_sgid_descriptions = []
  source_security_group_id  = []
}