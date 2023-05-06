resource "aws_vpc" "vpc" {
  cidr_block                       = "192.168.0.0/16"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    "Name"    = "${local.project}-${local.env}"
    "Project" = local.project
    "Env"     = local.env
  }
}

resource "aws_subnet" "private-rds-subnet-1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "192.168.3.0/24"
  map_public_ip_on_launch = false

  tags = {
    "Name"    = "${local.project}-${local.env}-private-subnet-1a"
    "Project" = local.project
    "Env"     = local.env
    "Type"    = "private"
  }
}

resource "aws_subnet" "private-rds-subnet-1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "192.168.4.0/24"
  map_public_ip_on_launch = false

  tags = {
    "Name"    = "${local.project}-${local.env}-private-subnet-1c"
    "Project" = local.project
    "Env"     = local.env
    "Type"    = "private"
  }
}
