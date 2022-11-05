resource "aws_security_group" "sg" {
  name        = var.name
  vpc_id      = var.vpc_id
  description = var.description
  tags = {
    "Name"       = var.name
    "Project"    = var.project
    "Enviroment" = var.enviroment
  }
}

resource "aws_security_group_rule" "db-sg-rule" {
  security_group_id        = aws_security_group.sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = "3306"
  to_port                  = "3306"
  source_security_group_id = aws_security_group.app_sg.id

}
