resource "aws_security_group" "app_sg" {
  name        = "${var.project}-${var.enviroment}-app-sg"
  vpc_id      = aws_vpc.vpc.id
  description = "app-sg"
  tags = {
    "Name"       = "${var.project}-${var.enviroment}-app-sg"
    "Project"    = var.project
    "Enviroment" = var.enviroment
  }
}

resource "aws_security_group" "db_sg" {
  name        = "${var.project}-${var.enviroment}-db-sg"
  vpc_id      = aws_vpc.vpc.id
  description = "db-sg"
  tags = {
    "Name"       = "${var.project}-${var.enviroment}-db-sg"
    "Project"    = var.project
    "Enviroment" = var.enviroment
  }
}

resource "aws_security_group_rule" "db-sg-rule" {
  security_group_id        = aws_security_group.db_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = "3306"
  to_port                  = "3306"
  source_security_group_id = aws_security_group.app_sg.id
}

resource "aws_security_group" "elasticache_sg" {
  name        = "${var.project}-${var.enviroment}-elasticache-sg"
  vpc_id      = aws_vpc.vpc.id
  description = "elasticache-sg"
  tags = {
    "Name"       = "${var.project}-${var.enviroment}-elasticache-sg"
    "Project"    = var.project
    "Enviroment" = var.enviroment
  }
}

resource "aws_security_group_rule" "elasticache-rule" {
  security_group_id        = aws_security_group.elasticache_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = "6379"
  to_port                  = "6379"
  source_security_group_id = aws_security_group.app_sg.id
}
