resource "aws_vpc" "vpc" {
  cidr_block                       = "192.170.0.0/16"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    "Name"    = "${var.project}-${var.enviroment}"
    "Project" = var.project
    "Env"     = var.enviroment
  }
}

resource "aws_subnet" "public-alb-subnet-1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "192.170.3.0/24"
  map_public_ip_on_launch = false

  tags = {
    "Name"    = "${var.project}-${var.enviroment}-public-alb-subnet-1a"
    "Project" = var.project
    "Env"     = var.enviroment
    "Type"    = "public"
  }
}

resource "aws_subnet" "public-alb-subnet-1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "192.170.4.0/24"
  map_public_ip_on_launch = false

  tags = {
    "Name"    = "${var.project}-${var.enviroment}-public-alb-subnet-1c"
    "Project" = var.project
    "Env"     = var.enviroment
    "Type"    = "public"
  }
}
