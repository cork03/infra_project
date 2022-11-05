terraform {
  required_version = ">= 1.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.34.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"
}

variable "project" {
  type    = string
  default = "project"
}

variable "enviroment" {
  type    = string
  default = "dev"
}

# DBのconf設定の役割
resource "aws_db_parameter_group" "mysql_parameter_group" {
  name   = "${var.project}-${var.enviroment}-mysql-parameter-group"
  family = "mysql8.0"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

# DBエンジンの設定
resource "aws_db_option_group" "mysql_option_group" {
  name                 = "${var.project}-${var.enviroment}-mysql-option-group"
  engine_name          = "mysql"
  major_engine_version = "8.0"
}

# RDSのサブネット設定
resource "aws_db_subnet_group" "mysql_subnet_group" {
  name = "${var.project}-${var.enviroment}-mysql-subnet-group"
  # マルチAZ用に複数指定
  subnet_ids = [
    aws_subnet.private-rds-subnet-1a.id,
    aws_subnet.private-rds-subnet-1c.id
  ]
}

# random string
resource "random_string" "db_password" {
  length  = 16
  special = false
}

resource "aws_db_instance" "db_instance" {
  identifier     = "${var.project}-${var.enviroment}-rds"
  engine         = "mysql"
  engine_version = "8.0"
  # user設定
  username = "admin"
  password = random_string.db_password.result
  # インスタンス設定
  instance_class        = "db.t2.micro"
  storage_type          = "gp2"
  allocated_storage     = 20
  max_allocated_storage = 50
  storage_encrypted     = false
  # ネットワーク系
  multi_az               = false
  availability_zone      = "ap-northeast-1a"
  db_subnet_group_name   = aws_db_subnet_group.mysql_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false
  port                   = 3306

  db_name              = "infraProject"
  parameter_group_name = aws_db_parameter_group.mysql_parameter_group.name
  option_group_name    = aws_db_option_group.mysql_option_group.name
  # backup系
  backup_window              = "04:00-05:00"
  backup_retention_period    = 7
  maintenance_window         = "Mon:05:00-Mon:08:00"
  auto_minor_version_upgrade = false

  # 削除系
  deletion_protection = false
  skip_final_snapshot = true

  apply_immediately = true

  tags = {
    "Name"       = "${var.project}-${var.enviroment}-rds-mysql"
    "Project"    = var.project
    "Enviroment" = var.enviroment
  }
}


