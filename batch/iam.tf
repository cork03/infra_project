data "aws_iam_policy" "ecs_events_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

module "cloud_watch_event" {
  source     = "../iam_role"
  name       = "ecs-events"
  policy     = data.aws_iam_policy.ecs_events_role_policy.policy
  # event bridge
  identifier = "events.amazonaws.com"
}
