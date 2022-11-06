resource "aws_security_group" "default" {
  name        = var.name
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "ingress" {
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = var.port
  to_port                  = var.port
  cidr_blocks = [ var.cidr_blocks ]
  security_group_id        = aws_security_group.default.id
}

resource "aws_security_group_rule" "egress" {
  type                     = "egress"
  protocol                 = "-1"
  from_port                = 0
  to_port                  = 0
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id        = aws_security_group.default.id
}

output "security_group_id" {
  value = aws_security_group.default.id
}
