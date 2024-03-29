resource "aws_vpc" "vpc" {
  cidr_block                       = "192.170.0.0/16"
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

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "${local.project}-${local.env}-internet-gateway"
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
    "Name"    = "${local.project}-${local.env}-public-alb-subnet-1a"
    "Project" = local.project
    "Env"     = local.env
    "Type"    = "public"
  }
}

resource "aws_subnet" "public-alb-subnet-1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "192.170.4.0/24"
  map_public_ip_on_launch = true

  tags = {
    "Name"    = "${local.project}-${local.env}-public-alb-subnet-1c"
    "Project" = local.project
    "Env"     = local.env
    "Type"    = "public"
  }
}

resource "aws_route_table" "public-alb" {
  vpc_id = aws_vpc.vpc.id
}

# route tableの1レコード
resource "aws_route" "public-alb" {
  route_table_id         = aws_route_table.public-alb.id
  gateway_id             = aws_internet_gateway.internet-gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

# subnetにroute tableを紐づける
resource "aws_route_table_association" "public-alb-1a" {
  subnet_id      = aws_subnet.public-alb-subnet-1a.id
  route_table_id = aws_route_table.public-alb.id
}

resource "aws_route_table_association" "public-alb-1c" {
  subnet_id      = aws_subnet.public-alb-subnet-1c.id
  route_table_id = aws_route_table.public-alb.id
}


####################################
# private subnet for ecs
####################################
# 1a
resource "aws_subnet" "private-ecs-subnet-1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "192.170.1.0/24"
  map_public_ip_on_launch = false

  tags = {
    "Name"    = "${local.project}-${local.env}-private-ecs-subnet-1a"
    "Project" = local.project
    "Env"     = local.env
    "Type"    = "private"
  }
}

resource "aws_route_table" "private-ecs-1a" {
  vpc_id = aws_vpc.vpc.id
}

# subnetにroute tableを紐づける
resource "aws_route_table_association" "private-ecs-1a" {
  subnet_id      = aws_subnet.private-ecs-subnet-1a.id
  route_table_id = aws_route_table.private-ecs-1a.id
}

# 1c
resource "aws_subnet" "private-ecs-subnet-1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "192.170.2.0/24"
  map_public_ip_on_launch = false

  tags = {
    "Name"    = "${local.project}-${local.env}-privatec-ecs-subnet-1c"
    "Project" = local.project
    "Env"     = local.env
    "Type"    = "private"
  }
}

resource "aws_route_table" "private-ecs-1c" {
  vpc_id = aws_vpc.vpc.id
}

# subnetにroute tableを紐づける
resource "aws_route_table_association" "private-ecs-1c" {
  subnet_id      = aws_subnet.private-ecs-subnet-1c.id
  route_table_id = aws_route_table.private-ecs-1c.id
}
