resource "aws_security_group" "app_sg" {
  name        = "${local.project}-${local.env}-app-sg"
  vpc_id      = aws_vpc.vpc.id
  description = "app-sg"
  tags = {
    "Name"       = "${local.project}-${local.env}-app-sg"
    "Project"    = local.project
    "Enviroment" = local.env
  }
}

resource "aws_security_group" "db_sg" {
  name        = "${local.project}-${local.env}-db-sg"
  vpc_id      = aws_vpc.vpc.id
  description = "db-sg"
  tags = {
    "Name"       = "${local.project}-${local.env}-db-sg"
    "Project"    = local.project
    "Enviroment" = local.env
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
  name        = "${local.project}-${local.env}-elasticache-sg"
  vpc_id      = aws_vpc.vpc.id
  description = "elasticache-sg"
  tags = {
    "Name"       = "${local.project}-${local.env}-elasticache-sg"
    "Project"    = local.project
    "Enviroment" = local.env
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
