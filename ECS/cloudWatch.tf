resource "aws_cloudwatch_log_group" "for_ecs" {
  name              = "/ecs/sample"
  retention_in_days = 180
}
