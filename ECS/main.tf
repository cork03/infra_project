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

resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${local.project}-${local.env}-ecs-cluster"
  #  cludewatch設定
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "ecs-service" {
  name            = "${local.project}-${local.env}-ecs-sercvice"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  # 維持するタスク数
  desired_count                     = 2
  launch_type                       = "FARGATE"
  platform_version                  = "1.4.0"
  health_check_grace_period_seconds = 5

  network_configuration {
    assign_public_ip = false
    security_groups  = [module.nginx_sg.security_group_id]
    subnets = [
      aws_subnet.private-ecs-subnet-1a.id,
      aws_subnet.private-ecs-subnet-1c.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs-target.arn
    container_name   = "example"
    container_port   = 80
  }

  # plan時に毎回差分が出てしまうためignoreする
  lifecycle {
    ignore_changes = [task_definition]
  }
}

####################################
# タスク定義
####################################
resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "${local.project}-${local.env}-ecs-task"
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = file("./container_definitions.json")
  execution_role_arn       = module.ecs_task_excution_role.iam_role_arn
}

module "nginx_sg" {
  source      = "../security_group"
  name        = "nginx_sg"
  vpc_id      = aws_vpc.vpc.id
  port        = 80
  cidr_blocks = [aws_vpc.vpc.cidr_block]
}
