# # トレース用のloggingをcloud watchで行う
# resource "aws_flow_log" "trace" {
#   iam_role_arn    = aws_iam_role.example.arn
#   log_destination = aws_cloudwatch_log_group.example.arn
#   traffic_type    = "ALL"
#   vpc_id          = aws_vpc.vpc.id
# }
