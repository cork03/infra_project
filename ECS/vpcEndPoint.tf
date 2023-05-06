resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${local.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    aws_route_table.private-ecs-1a.id,
    aws_route_table.private-ecs-1c.id
  ]
}

resource "aws_vpc_endpoint" "ecr-dkr" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${local.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  subnet_ids = [
    aws_subnet.private-ecs-subnet-1a.id,
    aws_subnet.private-ecs-subnet-1c.id
  ]
  security_group_ids = [ module.vpc_end_point.security_group_id ]
}

resource "aws_vpc_endpoint" "ecr-api" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${local.region}.ecr.api"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  subnet_ids = [
    aws_subnet.private-ecs-subnet-1a.id,
    aws_subnet.private-ecs-subnet-1c.id
  ]
  security_group_ids = [ module.vpc_end_point.security_group_id ]
}

resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${local.region}.secretsmanager"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  subnet_ids = [
    aws_subnet.private-ecs-subnet-1a.id,
    aws_subnet.private-ecs-subnet-1c.id
  ]
  security_group_ids = [ module.vpc_end_point.security_group_id ]
}

# resource "aws_vpc_endpoint" "ssm" {
#   vpc_id       = aws_vpc.vpc.id
#   service_name = "com.amazonaws.${local.region}.ssm"
#   vpc_endpoint_type = "Interface"
#   private_dns_enabled = true
#    subnet_ids = [
#   aws_subnet.private-ecs-subnet-1a.id,
#   aws_subnet.private-ecs-subnet-1c.id
# ]
# security_group_ids = [ module.vpc_end_point.security_group_id ]
# }

resource "aws_vpc_endpoint" "logs" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${local.region}.logs"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
   subnet_ids = [
    aws_subnet.private-ecs-subnet-1a.id,
    aws_subnet.private-ecs-subnet-1c.id
  ]
  security_group_ids = [ module.vpc_end_point.security_group_id ]
}

####################################
# security_groups
####################################
module "vpc_end_point" {
  source      = "../security_group"
  name        = "vpc_end_point"
  vpc_id      = aws_vpc.vpc.id
  port        = 443
  cidr_blocks = [
    aws_subnet.private-ecs-subnet-1a.cidr_block,
    aws_subnet.private-ecs-subnet-1c.cidr_block
  ]
}
