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

resource "aws_internet_gateway" "internat-gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "${var.project}-${var.enviroment}-internet-gateway"
  }
}

####################################
# public subnet for alb
####################################
resource "aws_subnet" "public-alb-subnet-1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "192.170.3.0/24"
  map_public_ip_on_launch = true

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
  map_public_ip_on_launch = true

  tags = {
    "Name"    = "${var.project}-${var.enviroment}-public-alb-subnet-1c"
    "Project" = var.project
    "Env"     = var.enviroment
    "Type"    = "public"
  }
}

####################################
# private subnet for ecs
####################################
resource "aws_subnet" "private-ecs-subnet-1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "192.170.1.0/24"
  map_public_ip_on_launch = false

  tags = {
    "Name"    = "${var.project}-${var.enviroment}-private-ecs-subnet-1a"
    "Project" = var.project
    "Env"     = var.enviroment
    "Type"    = "private"
  }
}

resource "aws_subnet" "private-ecs-subnet-1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "192.170.2.0/24"
  map_public_ip_on_launch = false

  tags = {
    "Name"    = "${var.project}-${var.enviroment}-privatec-ecs-subnet-1c"
    "Project" = var.project
    "Env"     = var.enviroment
    "Type"    = "private"
  }
}

resource "aws_route_table" "public-alb" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "public-alb" {
  route_table_id         = aws_route_table.public-alb.id
  gateway_id             = aws_internet_gateway.internat-gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public-alb-1a" {
  subnet_id      = aws_subnet.public-alb-subnet-1a.id
  route_table_id = aws_route_table.public-alb.id
}

resource "aws_route_table_association" "public-alb-1c" {
  subnet_id      = aws_subnet.public-alb-subnet-1c.id
  route_table_id = aws_route_table.public-alb.id
}
