resource "aws_cloudwatch_log_group" "schedule" {
  name              = "/ecs-schedule/sample"
  retention_in_days = 180
}

resource "aws_cloudwatch_event_rule" "batch" {
  name = "batch"
  description = "batch"
  schedule_expression = "cron(*/2 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "batch" {
  target_id = "batch"
  rule = aws_cloudwatch_event_rule.batch.name
  role_arn = module.cloud_watch_event.iam_role_arn
  arn = aws_ecs_cluster.ecs-cluster.arn

  ecs_target {
    launch_type = "FARGATE"
    task_count = 1
    platform_version = "1.4.0"
    task_definition_arn = aws_ecs_task_definition.ecs_schedule_task.arn

    network_configuration {
      assign_public_ip = "false"
      subnet = [aws_subnet.private-ecs-subnet-1a.id]
    }
  }
}
