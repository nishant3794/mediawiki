variable "description" { }
variable "tag_name" { }
variable "ingress_from_ports" { }
variable "ingress_to_ports" { }
variable "ingress_protocols" { }
variable "ingress_cidr_blocks" { }
variable "ingress_cidr_descriptions" { }
variable "ingress_sgid_from_ports" { }
variable "ingress_sgid_to_ports" { }
variable "ingress_sgid_protocols" { }
variable "ingress_sgid_descriptions" { }
variable "source_security_group_id" { }
variable "vpc_id" { }

resource "aws_security_group" "sg" {
  name                    = var.tag_name
  description             = var.description
  vpc_id                  = var.vpc_id
  tags = {
    Name                  = var.tag_name
  }
}

resource "aws_security_group_rule" "ingress-cidr" {
  count                   = length(var.ingress_from_ports)
  type                    = "ingress"
  from_port               = element(var.ingress_from_ports, count.index)
  to_port                 = element(var.ingress_to_ports, count.index)
  protocol                = element(var.ingress_protocols, count.index)
  cidr_blocks  	          = [element(var.ingress_cidr_blocks,count.index)]
  security_group_id       = aws_security_group.sg.id
  description             = element(var.ingress_cidr_descriptions, count.index)
}

resource "aws_security_group_rule" "ingress-sgid" {
  count                   = length(var.ingress_sgid_from_ports)
  type                    = "ingress"
  from_port               = element(var.ingress_sgid_from_ports, count.index)
  to_port                 = element(var.ingress_sgid_to_ports, count.index)
  protocol                = element(var.ingress_sgid_protocols, count.index)
  source_security_group_id = element(var.source_security_group_id, count.index)
  security_group_id       = aws_security_group.sg.id
  description             = element(var.ingress_sgid_descriptions, count.index)
}

resource "aws_security_group_rule" "egress" {
  type                    = "egress"
  from_port               = 0
  to_port                 = 65535
  protocol                = "tcp"
  cidr_blocks             = ["0.0.0.0/0"]
  security_group_id       = aws_security_group.sg.id
}
output "security-group-id" { value = "${aws_security_group.sg.id}" }