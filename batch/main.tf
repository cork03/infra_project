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


resource "aws_ecs_task_definition" "ecs_schedule_task" {
  family                   = "${local.project}-${local.env}-ecs-schedule-task"
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = file("./schedule_definitions.json")
  execution_role_arn       = module.ecs_task_excution_role.iam_role_arn
}
